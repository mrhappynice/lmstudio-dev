Local web GUI with LM Studio and MCP support. Add your SearXNG URL for search. (adding SearXNG, WIP)

run with:
```bash
docker run --rm -d \
  --device /dev/fuse \
  --cap-add SYS_ADMIN \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --add-host=host.docker.internal:host-gateway \
  -p 3000:3000 -p 8080:8080 -p 3333:3333 -p 3001:3001 \
  -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago \
  -v $(pwd)/config:/config \
  --name combined1 \
  mrhappynice/webgui-lms-mcp

```

- Connect to with browser to port 3001 ex: https://localhost:3001
- Open a terminal anywhere once loaded and type:```lmstudio```
  - or browse to /opt/lmstudio and run AppImage

- mcp.json for LMS:
```bash
{
  "mcpServers": {
    "searxng": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-searxng"
      ],
      "env": {
        "SEARXNG_URL": "http://host.docker.internal:8080"
      }
    }
  }
}
```

- You do still need to run or have access to a SearXNG server, add the URL.  Or run the compose file in the easy-searx-mcp for SearXNG server. 
