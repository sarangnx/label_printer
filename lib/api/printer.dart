import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class Printer {
  UsbDevice? device;
  late UsbPort port;

  Future<void> init() async {
    try {
      List<UsbDevice> devices = await UsbSerial.listDevices();

      if (devices.isEmpty) {
        throw Exception('No USB devices found');
      }

      device = devices[0];

      port = await device!.create() as UsbPort;

      if (!(await port.open())) {
        throw Exception('Failed to open USB port');
      }

      // Set port parameters (baud rate, data bits, stop bits, parity)
      await port.setDTR(true);
      await port.setRTS(true);
      await port.setPortParameters(9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    } catch (e) {
      print('Error initializing printer: $e');
    }
  }

  Future<void> sendCommand(String command) async {
    try {
      Uint8List com = Uint8List.fromList(utf8.encode(command));
      await port.write(com);
    } catch (e) {
      print('Error sending command: $e');
    }
  }

  Future<void> dispose() async {
    try {
      if (port != null) {
        await port.close();
      }
    } catch (e) {
      print('Error disposing printer: $e');
    }
  }

  Future<void> text({
    required String text,
    required int x,
    required int y,
    required String font,
    int mx = 1,
    int my = 1,
  }) async {
    await sendCommand('TEXT $x, $y, "$font", 0, $mx , $my, "$text" \r\n');
  }

  Future<void> printLabel(Map<String, dynamic> data) async {
    await sendCommand('SIZE 100 mm,30 mm\r\n');
    await sendCommand('GAP 2.5 mm,0 mm\r\n');
    await sendCommand('CLS\r\n');
    await sendCommand('REFERENCE 0,0\r\n');

    await text(text: data['name'], x: 30, y: 30, font: 'B.FNT', mx: 2, my: 3);
    await text(text: data['name'], x: 430, y: 30, font: 'B.FNT', mx: 2, my: 3);

    await text(text: '${data['dateType']}:', x: 30, y: 80, font: '3.EFT');
    await text(text: '${data['dateType']}:', x: 430, y: 80, font: '3.EFT');

    if (data['dateType'] == 'Date') {
      await text(text: data['date'], x: 110, y: 82, font: 'D.FNT');
      await text(text: data['date'], x: 510, y: 82, font: 'D.FNT');
    } else {
      await text(text: data['date'], x: 200, y: 82, font: 'D.FNT');
      await text(text: data['date'], x: 600, y: 82, font: 'D.FNT');
    }

    var padding = 0;

    if (data['showDate2']) {
      padding = 30;
      await text(text: 'Expiry Date:', x: 30, y: 110, font: '3.EFT');
      await text(text: 'Expiry Date:', x: 430, y: 110, font: '3.EFT');
      await text(text: data['date'], x: 200, y: 112, font: 'D.FNT');
      await text(text: data['date'], x: 600, y: 112, font: 'D.FNT');
    }

    await text(text: '${data['quantityType']}:', x: 30, y: 110 + padding, font: '3.EFT');
    await text(text: '${data['quantityType']}:', x: 430, y: 110 + padding, font: '3.EFT');
    await text(text: data['quantity'], x: 130, y: 112 + padding, font: 'D.FNT');
    await text(text: data['quantity'], x: 530, y: 112 + padding, font: 'D.FNT');

    await text(text: 'MRP:', x: 30, y: 140 + padding, font: '3.EFT');
    await text(text: 'MRP:', x: 430, y: 140 + padding, font: '3.EFT');
    await text(text: data['mrp'], x: 90, y: 142 + padding, font: 'D.FNT');
    await text(text: data['mrp'], x: 490, y: 142 + padding, font: 'D.FNT');

    if (data['bestBefore'] != null) {
      var message = 'Best before ${data['bestBefore']}';
      await text(text: message, x: 30, y: 170 + padding, font: 'D.FNT');
      await text(text: message, x: 430, y: 170 + padding, font: 'D.FNT');
    }

    if (data['phone'] != null && data['phone'] != '') {
      await text(text: 'Customer Care: ${data['phone']}', x: 30, y: 200, font: '0', mx: 6, my: 5);
      await text(text: 'Customer Care: ${data['phone']}', x: 430, y: 200, font: '0', mx: 6, my: 5);
    }

    if (data['fssai'] != null && data['fssai'] != '') {
      await text(text: 'fssai: ${data['fssai']}', x: 30, y: 220, font: '0', mx: 6, my: 5);
      await text(text: 'fssai: ${data['fssai']}', x: 430, y: 220, font: '0', mx: 6, my: 5);
    }

    if (data['address'] != null && data['address'] != '') {
      await sendCommand('BLOCK 240, 190, 160, 50, "0", 0, 6, 5, "MFD BY: ${data['address']}" \r\n');
      await sendCommand('BLOCK 640, 190, 160, 50, "0", 0, 6, 5, "MFD BY: ${data['address']}" \r\n');
    }

    int copies = int.tryParse(data['copies']) ?? 1;
    copies = (copies / 2).ceil();

    await sendCommand('PRINT $copies\r\n');

    await dispose();
  }
}
