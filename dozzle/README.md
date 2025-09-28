# Home Assistant Add-on: Dozzle

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

A simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live. It doesn't store any log files. It is for live monitoring of your container logs only.

## About

Dozzle is a simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live. It doesn't require any configuration and is designed to be used as a temporary debugging tool.

This Home Assistant add-on packages Dozzle and automatically tracks updates from the upstream repository at https://github.com/amir20/dozzle.

## Installation

1. Add this repository to your Home Assistant instance.
2. Install the "Dozzle" add-on.
3. Start the "Dozzle" add-on.
4. Check the logs of the "Dozzle" add-on to see if everything went well.
5. Open the web interface at http://homeassistant.local:8080.

## Configuration

### Option: `remote_host`

Connect to a remote Docker host. Format: `tcp://host:2376` for secure connections or `tcp://host:2375` for insecure connections.

### Option: `remote_user`

Username for remote Docker host authentication.

### Option: `remote_key`

Private key path for remote Docker host authentication.

### Option: `no_analytics`

Disable Google Analytics. Default is `true`.

### Option: `enable_actions`

Enable container actions (start, stop, restart). Use with caution. Default is `false`.

### Option: `hostname`

Custom hostname for the web interface.

### Option: `base`

Base path for reverse proxy setups (e.g., `/dozzle`).

### Option: `level`

Log level for Dozzle itself. Options: `trace`, `debug`, `info`, `warn`, `error`, `fatal`, `panic`.

### Option: `auth_provider`

Authentication provider. Options: `none`, `forward-proxy`.

### Option: `auth_header_user`

Header name for username when using forward-proxy authentication.

### Option: `auth_header_email`

Header name for email when using forward-proxy authentication.

### Option: `auth_header_name`

Header name for display name when using forward-proxy authentication.

### Option: `filter`

Filter containers by name or label. Supports regex patterns.

## Example Configuration

```yaml
remote_host: "tcp://192.168.1.100:2376"
remote_user: "docker-user"
no_analytics: true
enable_actions: false
level: "info"
filter: "name=myapp.*"
```

## Support

Got questions? Please use the [GitHub Discussions][discussions] for general questions, or visit the [Community Forum][forum] for Home Assistant specific questions.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[discussions]: https://github.com/kernelkaribou/homeassistant/discussions
[forum]: https://community.home-assistant.io