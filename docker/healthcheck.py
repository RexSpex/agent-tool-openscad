import pathlib
import socket
import urllib.request

for port in (5900, 6080, 8000, 8080):
    with socket.create_connection(("127.0.0.1", port), timeout=3):
        pass
assert pathlib.Path("/tmp/.X11-unix/X0").exists()
with urllib.request.urlopen("http://127.0.0.1:8080/healthz", timeout=3) as response:
    assert response.status == 200
