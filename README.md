# Horde/UBA with Wine

⚠️ **This repo uses Git LFS; you'll need to clone it with LFS installed!**

## Horde Server/Coordinator

1. On a Linux computer that you want to act as the server, copy the `docker-compose.yml` file to some directory (e.g. `~/Horde`)
1. Make sure you [have/get access](https://dev.epicgames.com/documentation/en-us/unreal-engine/downloading-unreal-engine-source-code#accessingunrealenginesourcecodeongithub) to Epic's GitHub repos: https://github.com/epicgames/unrealengine
1. Make sure you're [authenticated with ghcr.io via `docker login` (GitHub Container Registry)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry)
1. Navigate to that directory in the terminal and run `docker compose up -d`
1. Check to see if it has deployed by navigating to port `http://ip:13340` for this server (and/or check `docker compose logs -f`)

## Horde Linux Agents (with UBA and Wine)

1. Either on the server or on your local machine (as long as you have access to the server's URL), build the agent image, which will details from the server. Make sure to replace `ip` with your ip/host:
    ```bash
    docker build . -f agent.Dockerfile -t horde-agent --build-arg HORDE_SERVER_URL=http://ip:13340
    ```
1. Optionally push this docker image to your container registry to be used elsewhere; running the image should auto connect/authenticate to the server
1. Once agents are started, you need to approve them at `http://ip:13340/agents/registration`. Select all and click **Enroll Agents**
1. You can see the list of agents at `http://ip:13340/agents`
1. Select all of the Linux agents and under the **X Agents Selected** button, click **Edit Pools** and add `Win-UE5` and check the **Conform Immediately** checkbox, click **Update**

## Windows Initiator

1. I tested this with the [Lyra Starter Game](https://www.unrealengine.com/marketplace/en-US/product/lyra) on 5.4.4 both by installing via the Epic Games Launcher. I won't cover how to download both of those and set up that project unless you want me to.
1. Once I created the Lyra project from the Vault section in the Epic Games Section, I opened the project and generated a VS solution with Tools > Generate Visual Studio Project Files... (or something similar)
1. Close Unreal
1. Copy/merge the contents of this repo's [BuildConfiguration.xml](./BuildConfiguration.xml) into `%APPDATA%/Unreal Engine/UnrealBuildTool`
1. Modify `%APPDATA%/Unreal Engine/UnrealBuildTool/BuildConfiguration.xml` and edit the `Horde.Server` variable to point to your Horde server/coordinator. Optionally comment out/remove the `UnrealBuildAccelerator.bLaunchVisualizer` if you don't want to see a GUI showing the distributed build progress. You can also remove `UnrealBuildAccelerator.bForceBuildAllRemote` if you want the local Windows machine to build; I have this to showcase that everything is being done remotely

## Note about networking

The Windows Initiator opens a P2P connection with the UBA agents (remember the Horde Agent includes UBA), so it needs to be able to access them via their reported IP and ports 7000-7002.

## Running

Simply, here's a command to package the project on the Windows initiator:

```
"C:\Program Files\Epic Games\UE_5.4\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -project="C:\Path\To\LyraProject\LyraProject.uproject" -noP4 -platform=Win64 -config=Development -cook -build -stage -pak -iostore -cook4iostore -archive -archivedirectory="C:\Path\To\Some\Output\Dir" -unattended
```

This will compile C++, cook shaders/assets, and create a build that is consumable by a player.
