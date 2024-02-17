# Development Container for ROS 2 on M1/M2 Macs

This Dockerfile is designed to create a Docker container specifically for ROS 2 Humble, optimized for M1/M2 Macs (ARM64 architecture).

## Getting Started

### Prerequisites
- Docker installed on your M1/M2 Mac

### Setup Instructions

1. **Install Docker for M1/M2 Mac**: 
   Follow the official Docker installation guide for ARM64-based Macs.
2. **Build the Container**: 
   Run the build script with the region code as an argument. For instance, for Japanese, use

   ```
   ./build_container.sh JP
   ```
   
   For other regions, replace `JP` with the appropriate region code (e.g., `US` for United States).
4. **Start the Container**: 
   Initiate the container with

   ```
   ./start_container.sh
   ```
   
6. **Commit Changes**: 
   Save the current state of the Docker container using

   ```
   ./stop_container.sh
   ```
   
8. **Access the Container**: 
   For terminal access, run

   ```
   ./attach_container.sh
   ```
   
   to use bash inside the Docker container.
10. **Desktop Environment**: 
   To use the KDE Plasma Desktop via xrdp, connect using an RDP client to `127.0.0.1` or `localhost`.

### Recommended RDP Clients

- **Microsoft Remote Desktop**: 
  Supports sound playback. Note: The Japanese keyboard layout may not allow input of the underscore character (`_`).
- **Parallels Client**: 
  Allows the input of underscore (`_`) using a Japanese keyboard. However, sound playback is not supported.

These steps will guide you through setting up and using a ROS 2 Docker container on your M1/M2 Mac, including desktop access through RDP. Choose the RDP client that best fits your needs based on the provided recommendations.
