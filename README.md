# KernelKaribou's Home Assistant Add-ons

This repository contains custom Home Assistant add-ons maintained by KernelKaribou.

## Add-ons

### Dozzle
A simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live.

**Version:** 8.14.2  
**Architectures:** amd64, aarch64, armv7  
**Website:** https://dozzle.dev

#### Features
- Real-time Docker container log monitoring
- Web-based interface
- Support for remote Docker hosts
- Authentication options
- Filtering capabilities

#### Configuration Options
- `remote_host`: Remote Docker host (optional)
- `remote_user`: Remote Docker user (optional)
- `remote_key`: SSH key for remote access (optional)
- `no_analytics`: Disable analytics (default: true)
- `enable_actions`: Enable container actions (default: false)
- `hostname`: Custom hostname display (optional)
- `base`: Base path for reverse proxy (optional)
- `level`: Log level (info, debug, etc.)
- `auth_provider`: Authentication provider (none, forward-proxy)
- `filter`: Log filtering (optional)

## Installation

1. Add this repository to your Home Assistant add-on store:
   ```
   https://github.com/kernelkaribou/homeassistant
   ```

2. Refresh the add-on store

3. Install the desired add-on

## Development

This repository uses GitHub Actions for automated building and publishing of add-ons. The container images are built and stored as GitHub Packages within this repository, making it completely self-contained.

### Automated Workflow

When a new version of Dozzle is released, the workflow automatically:

1. Detects the new version via GitHub API
2. Updates configuration files (`config.yaml` and `build.yaml`)
3. Builds multi-architecture Docker images (amd64, aarch64, armv7)
4. Publishes images as GitHub Packages in this repository
5. Commits version updates back to the repository
6. Cleans up old package versions to save storage space

### Manual Building

You can also build the addon locally using the provided script:

```bash
cd dozzle
chmod +x build-local.sh
./build-local.sh
```

### Container Images

The built images are available at:
```
ghcr.io/kernelkaribou/homeassistant/addon-dozzle-amd64:latest
ghcr.io/kernelkaribou/homeassistant/addon-dozzle-aarch64:latest
ghcr.io/kernelkaribou/homeassistant/addon-dozzle-armv7:latest
```

## Contributing

Feel free to open issues or submit pull requests for improvements.

## License

This project is licensed under the MIT License.
