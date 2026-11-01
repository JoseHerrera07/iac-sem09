#!/bin/bash
# API minima de demostracion: responde en /health y en /
set -euo pipefail

mkdir -p /opt/api

cat > /opt/api/app.py <<'PY'
import json
import socket
from http.server import BaseHTTPRequestHandler, HTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body = {"status": "ok"}
        else:
            body = {"service": "transandes-api", "instancia": socket.gethostname()}
        data = json.dumps(body).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


HTTPServer(("0.0.0.0", 80), Handler).serve_forever()
PY

cat > /etc/systemd/system/api.service <<'UNIT'
[Unit]
Description=TransAndes API demo
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/api/app.py
Restart=always

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable --now api.service
