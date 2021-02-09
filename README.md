# label_printer

Flutter app for printing labels on ESC/POS thermal printer. Model: TSC TE200

## Getting Started

```bash
# install dependencies
flutter packages get

# check for connected deviecs
flutter devices
```

## Connecting device over wifi

[Connect adb over network.](https://stackoverflow.com/questions/2604727/how-can-i-connect-to-android-with-adb-over-tcp)

```bash
# first connect with usb
adb tcpip <port>

# disconnect usb and type this in terminal
adb connect <ip of device>:<port>
```