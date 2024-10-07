# Horde/UBA with Wine

⚠️ **This repo uses Git LFS; you'll need to clone it with LFS installed!**

1. On a Linux computer that you want to act as the server, copy the `docker-compose.yml` file to some directory (e.g. `~/Horde`)
1. Make sure you [have/get access](https://dev.epicgames.com/documentation/en-us/unreal-engine/downloading-unreal-engine-source-code#accessingunrealenginesourcecodeongithub) to Epic's GitHub repos: https://github.com/epicgames/unrealengine
1. Make sure you're [authenticated with ghcr.io via `docker login` (GitHub Container Registry)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)
1. Navigate to that directory in the terminal and run `docker compose up -d`
1. Check to see if it has deployed by navigating to port `http://ip:13340` for this server (and/or check `docker compose logs -f`)
1. Either on the server or on your local machine (as long as you have access to the server's URL), build the agent image, which will details from the server. Make sure to replace `ip` with your ip/host:
    ```bash
    docker build . -f agent.Dockerfile -t horde-agent --build-arg HORDE_SERVER_URL=http://ip:13340
    ```
1. Optionally push this docker image to your container registry to be used elsewhere; running the image should auto connect/authenticate to the server
1. On your local Windows machine that will initiate the build, download and run the Horde Agent Installer: `http://ip:13340/api/v1/tools/horde-agent-win64-installer?action=download`
1. Once agents are started, you need to approve them at `http://ip:13340/agents/registration`. Select all and click **Enroll Agents**
1. You can see the list of agents at `http://ip:13340/agents`