# Home Assistant Add-on: Dozzle

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armv7 Architecture][armv7-shield]

This is a home assistant addon for [Dozzle](https://dozzle.dev), a simple, lightweight application that provides you with a web based interface to monitor your Docker container logs live. It doesn't store any log files. It is for live monitoring of your container logs only.

This Home Assistant add-on packages Dozzle and automatically tracks updates from the upstream repository at https://github.com/amir20/dozzle.

## Installation

1. Add this repository to your Home Assistant instance.
2. Install the "Dozzle" add-on.
3. Update all desired configuration settings, more info at [dozzle.dev](https://dozzle.dev)
4. Start the "Dozzle" add-on.
5. Check the logs of the "Dozzle" add-on to see if everything went well.
6. Open the web interface at http://homeassistant.local:8080.

## Credit

Want to thank the Dozzle project for all their efforts and providing the basis of this addon. Recommend supporting the project on [Github](https://github.com/amir20/dozzle)

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg