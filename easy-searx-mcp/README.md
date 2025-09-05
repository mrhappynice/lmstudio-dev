## Setup Searxng + MCP in LMS


- Have Docker installed: [Install Docker](https://docs.docker.com/engine/install/)  
- git the files, (optional: change secrect key in searxng/settings.yml)
  ```bash
  git clone https://github.com/mrhappynice/lmstudio-dev.git
  ```
- run docker compose in this directory (easy-searx-mcp) with compose.yml:
  ```bash
  docker compose up -d
  ```
- copy mcp json into LM Studio, then restart.
- Switch on the plugin/mcp in chat, enjoy :)
  
