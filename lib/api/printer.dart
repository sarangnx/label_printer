import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_usb_write/flutter_usb_write.dart';

class Printer {
  FlutterUsbWrite usb = FlutterUsbWrite();
  UsbDevice device;

  Future init() async {
    try {
      List<UsbDevice> devices = await usb.listDevices();

      device = devices[0];

      await usb.open(vendorId: device.vid, productId: device.pid);
    } catch (e) {
      print(e);
    }
  }

  Future sendCommand(String command) async {
    Uint8List com = utf8.encode(command);
    try {
      await usb.write(com);
    } catch (e) {
      print(e);
    }
  }

  Future dispose() async {
    if (usb != null) {
      await usb.close();
    }
  }

  /// Send Command to print TEXT
  ///
  /// Send [text] to printer memory. [x] and [y] are coordinates to place the
  /// [text]. [font] is the name of font supported by printer.
  /// [mx] and [my] are used to multiply base font size to get desired size.
  Future text({
    String text,
    int x,
    int y,
    String font,
    int mx = 1,
    int my = 1,
  }) async {
    await sendCommand(
      'TEXT $x, $y, "$font", 0, $mx , $my, "$text" \r\n',
    );
  }

  Future printLabel(Map<String, dynamic> data) async {
    // Initialize Print Properties
    await sendCommand('SIZE 100 mm,30 mm\r\n');
    await sendCommand('GAP 2.5 mm,0 mm\r\n');
    await sendCommand('CLS\r\n');

    // Take top left corner of label as reference point
    // (x, y) coordinates are calculated by taking
    // 1mm = 8 dots (for 203 dpi printer)
    //
    // 100x30 mm label = 800x240 dots
    await sendCommand('REFERENCE 0,0\r\n');

    // Name
    await text(text: data['name'], x: 30, y: 30, font: 'B.FNT', mx: 2, my: 3);
    await text(text: data['name'], x: 430, y: 30, font: 'B.FNT', mx: 2, my: 3);

    // Date Type
    await text(text: '${data['dateType']}:', x: 30, y: 80, font: '3.EFT');
    await text(text: '${data['dateType']}:', x: 430, y: 80, font: '3.EFT');

    // Date
    if (data['dateType'] == 'Date') {
      await text(text: data['date'], x: 110, y: 82, font: 'D.FNT');
      await text(text: data['date'], x: 510, y: 82, font: 'D.FNT');
    } else {
      await text(text: data['date'], x: 200, y: 82, font: 'D.FNT');
      await text(text: data['date'], x: 600, y: 82, font: 'D.FNT');
    }

    var padding = 0;

    // Date 2
    if (data['showDate2']) {
      // If date2 is needed, shift everything down by 30
      padding = 30;

      // Date Type
      await text(text: 'Expiry Date:', x: 30, y: 110, font: '3.EFT');
      await text(text: 'Expiry Date:', x: 430, y: 110, font: '3.EFT');

      // Date Value
      await text(text: data['date'], x: 200, y: 112, font: 'D.FNT');
      await text(text: data['date'], x: 600, y: 112, font: 'D.FNT');
    }

    // Quantity Type
    await text(
      text: '${data['quantityType']}:',
      x: 30,
      y: 110 + padding,
      font: '3.EFT',
    );
    await text(
      text: '${data['quantityType']}:',
      x: 430,
      y: 110 + padding,
      font: '3.EFT',
    );

    // Quantity
    await text(text: data['quantity'], x: 130, y: 112 + padding, font: 'D.FNT');
    await text(text: data['quantity'], x: 530, y: 112 + padding, font: 'D.FNT');

    // MRP Label
    await text(text: 'MRP:', x: 30, y: 140 + padding, font: '3.EFT');
    await text(text: 'MRP:', x: 430, y: 140 + padding, font: '3.EFT');

    // MRP
    await text(text: data['mrp'], x: 90, y: 142 + padding, font: 'D.FNT');
    await text(text: data['mrp'], x: 490, y: 142 + padding, font: 'D.FNT');

    // Phone
    if (data['phone'] != null && data['phone'] != '') {
      await text(
        text: 'Customer Care: ${data['phone']}',
        x: 30,
        y: 200,
        font: '0',
        mx: 6,
        my: 5,
      );
      await text(
        text: 'Customer Care: ${data['phone']}',
        x: 430,
        y: 200,
        font: '0',
        mx: 6,
        my: 5,
      );
    }

    // Fssai
    if (data['fssai'] != null && data['fssai'] != '') {
      await text(
        text: 'fssai: ${data['fssai']}',
        x: 30,
        y: 220,
        font: '0',
        mx: 6,
        my: 5,
      );
      await text(
        text: 'fssai: ${data['fssai']}',
        x: 430,
        y: 220,
        font: '0',
        mx: 6,
        my: 5,
      );
    }

    // address
    if (data['address'] != null && data['address'] != '') {
      await sendCommand(
        'BLOCK 240, 190, 160, 50, "0", 0, 6, 5, "MFD BY: ${data['address']}" \r\n',
      );
      await sendCommand(
        'BLOCK 640, 190, 160, 50, "0", 0, 6, 5, "MFD BY: ${data['address']}" \r\n',
      );
    }

    int copies = int.tryParse(data['copies']) ?? 1;
    copies = (copies / 2).ceil();

    await sendCommand('PRINT $copies\r\n');

    await dispose();
  }
}
