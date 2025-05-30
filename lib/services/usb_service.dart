import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

  static Future<void> openConnection() async {
    try {
      final bool success = await _channel.invokeMethod('openConnection');

      if (!success) {
        throw Exception('Failed to open connection');
      }
    } catch (e) {
      print('Error opening device: $e');
    }
  }

  static Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose');
    } catch (e) {
      print('Error closing device: $e');
    }
  }

  static Future<void> write(Uint8List data) async {
    try {
      final dynamic res = await _channel.invokeMethod('writeData', {'data': data});

      debugPrint('bytes: $res');
    } catch (e) {
      print('Error writing data: $e');
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
