import 'package:flutter/services.dart';

class UsbService {
  static const MethodChannel _channel = MethodChannel('com.sarang.label/usb');

  static Future<List<UsbDevice>> listDevices() async {
    final List<dynamic> devices = await _channel.invokeMethod('getUsbDevices');
    return devices.map((device) => UsbDevice.fromMap(Map<String, dynamic>.from(device))).toList();
  }

  static Future<bool> requestPermission(int deviceId) async {
    try {
      final bool success = await _channel.invokeMethod('requestUsbPermission', {'deviceId': deviceId});
      return success;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }
}

class UsbDevice {
  final String deviceName;
  final int deviceId;
  final int vendorId;
  final int productId;

  UsbDevice({required this.deviceName, required this.deviceId, required this.vendorId, required this.productId});

  // Factory constructor to create an instance from a Map
  factory UsbDevice.fromMap(Map<String, dynamic> map) {
    return UsbDevice(
      deviceName: map['deviceName'] ?? '',
      deviceId: map['deviceId'] is int ? map['deviceId'] : int.tryParse(map['deviceId'] ?? '0') ?? 0,
      vendorId: map['vendorId'] is int ? map['vendorId'] : int.tryParse(map['vendorId'] ?? '0') ?? 0,
      productId: map['productId'] is int ? map['productId'] : int.tryParse(map['productId'] ?? '0') ?? 0,
    );
  }

  // Convert the instance back to a Map
  Map<String, dynamic> toMap() {
    return {'deviceName': deviceName, 'deviceId': deviceId, 'vendorId': vendorId, 'productId': productId};
  }
}
