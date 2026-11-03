#!/bin/sh
set -eu
mkdir -p /workspace/models /workspace/exports /home/cad/.config
mkdir -p /home/cad/.fluxbox
if [ ! -f /home/cad/.fluxbox/init ]; then
  printf '%s\n' 'session.screen0.styleOverlay: /home/cad/.fluxbox/overlay' > /home/cad/.fluxbox/init
fi
if [ ! -f /home/cad/.fluxbox/overlay ]; then
  printf '%s\n' 'background: unset' > /home/cad/.fluxbox/overlay
fi
if [ ! -f /home/cad/.fluxbox/apps ]; then
  printf '%s\n' '[app] (name=openscad)' '  [Maximized] {yes}' '[end]' > /home/cad/.fluxbox/apps
fi
if [ ! -f /workspace/models/welcome.scad ]; then
  printf '%s\n' '// Shared agent workspace. Units: mm.' 'difference() { cube([30,30,10], center=true); cylinder(h=12,d=8,center=true,$fn=64); }' > /workspace/models/welcome.scad
fi
exec /usr/bin/supervisord -c /opt/supervisord.conf
