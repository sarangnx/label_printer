import 'dart:async';

import '../services/usb_service.dart';

class Printer {
  late UsbDevice device;

  Future<void> init() async {
    List<UsbDevice> devices = await UsbService.listDevices();

    device = devices.first;

    bool success = await UsbService.requestPermission(device!.deviceId);

    if (!success) {
      throw Exception('Permission denied');
    }
  }
}
