# Development Container for ROS 2 on M1/2 Mac
 This docker file makes the container of ROS 2 Humble for M1 Mac (ARM64)

## How to use
1. Install docker for M1 Mac
2. Build container : execute "./build_container.sh \<JP or US\>" (for Japanese : "./build_container.sh JP")
3. Start Container : execute "./start_container.sh"
4. Commit docker container : "./stop_container.sh"
5. Attach docker container and use bash : "./attach_container.sh"
6. Use KDE Plasma Desktop via xrdp : use RDP Client and access to 127.0.0.1 or localhost.

## Recommended RDP Client

- Microsoft Remote Desktop

Support sound but cannot input "_" by JP keyboard

- Parallels Client

Support "_" by JP keyboard but sound is not suported
