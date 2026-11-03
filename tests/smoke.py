import base64, json, os, socket, ssl, sys, urllib.request, uuid
from urllib.parse import urlparse
origin = (sys.argv[1] if len(sys.argv)>1 else "http://localhost:48321").rstrip("/")
with urllib.request.urlopen(origin + "/", timeout=15) as response:
    assert response.status == 200
    assert response.url.startswith(origin + "/vnc.html?"), response.url
with urllib.request.urlopen(origin + "/vnc.html", timeout=15) as response:
    assert response.status == 200
address=urlparse(origin)
port=address.port or (443 if address.scheme=="https" else 80)
conn=socket.create_connection((address.hostname,port),timeout=15)
if address.scheme=="https":
    conn=ssl.create_default_context().wrap_socket(conn,server_hostname=address.hostname)
with conn:
    key=base64.b64encode(os.urandom(16)).decode()
    headers=f"GET /websockify HTTP/1.1\r\nHost: {address.netloc}\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: {key}\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Protocol: binary\r\n\r\n"
    conn.sendall(headers.encode())
    data=conn.recv(4096)
    assert b"101 Switching Protocols" in data, data[:200]
    if b"RFB " not in data:
        data+=conn.recv(4096)
    assert b"RFB 003.008" in data, data[:200]
print("Desktop redirect and VNC handshake pass")
import json, urllib.request, sys
base = origin + "/mcp"
session = None
sequence = 0
def rpc(method, params=None, notify=False):
    global session, sequence
    sequence += 1
    payload = {'jsonrpc':'2.0','method':method, 'params':params or {}}
    if not notify:
        payload['id'] = sequence
    headers = {'Content-Type':'application/json','Accept':'application/json, text/event-stream'}
    if session:
        headers['Mcp-Session-Id'] = session
    request = urllib.request.Request(base, data=json.dumps(payload).encode(),headers=headers)
    with urllib.request.urlopen(request, timeout=150) as response:
        session = response.headers.get('Mcp-Session-Id', session)
        raw = response.read().decode()
    if notify:
        return
    messages = [json.loads(line[6:]) for line in raw.splitlines() if line.startswith('data: ')] if any(line.startswith('data: ') for line in raw.splitlines()) else [json.loads(raw)]
    for message in messages:
        if message.get('id') == sequence:
            if 'error' in message:
                raise RuntimeError(message['error'])
            return message['result']
    raise RuntimeError('Missing JSON-RPC response')
def call(name, arguments):
    result = rpc('tools/call', {'name':name,'arguments':arguments})
    assert not result.get('isError'), str(result)[:500]
    contents = result.get('content', [])
    texts = [block['text'] for block in contents if block['type']=='text']
    print(name, 'OK', str(texts)[:400], 'images',sum(block['type']=='image' for block in contents))
    for value in texts:
        try:
            data=json.loads(value)
        except ValueError:
            continue
        if isinstance(data, dict):
            assert data.get('success',True), value[:500]
    return result

rpc('initialize',{'protocolVersion':'2024-11-05','capabilities':{},'clientInfo':{'name':'portable-smoke','version':'1'}})
rpc('notifications/initialized',notify=True)
names={tool['name'] for tool in rpc('tools/list')['tools']}
assert {'model','render','export_model','measure','check_openscad'} <= names
call('check_openscad',{})
workspace='/workspace/.smoke'
name='portable-cube'
existing=rpc('tools/call',{'name':'model','arguments':{'action':'get','name':name,'workspace':workspace}})
if any(json.loads(c['text']).get('success') for c in existing.get('content',[]) if c['type']=='text'):
    print('Persistent smoke model found')
else:
    call('model',{'action':'create','name':name,'workspace':workspace,'content':'cube([10,20,30]);'})
path=workspace+'/'+name+'.scad'
rendered=call('render',{'scad_file':path,'views':['isometric'],'image_size':[640,480]})
assert any(c['type']=='image' for c in rendered.get('content',[]))
call('export_model',{'scad_file':path,'output_path':workspace+'/'+name+'.stl'})
measured=call('measure',{'mesh':workspace+'/'+name+'.stl','mode':'model'})
data=next(json.loads(c['text']) for c in measured['content'] if c['type']=='text')
assert data['dimensions']==[10.0,20.0,30.0],data
assert abs(data['volume']-6000)<0.001,data
assert data['is_watertight'],data
print('All portable smoke checks pass')
