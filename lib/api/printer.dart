import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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

    await UsbService.openConnection();
    print('device connected');
  }

  Future<void> sendCommand(String command) async {
    try {
      Uint8List com = utf8.encode(command);

      await UsbService.write(com);
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendCommandBytes(List<int> bytes) async {
    try {
      Uint8List com = Uint8List.fromList(bytes);
      await UsbService.write(com);
    } catch (e) {
      print('Error sending command: $e');
    }
  }

  /// Send Command to print TEXT
  ///
  /// Send [text] to printer memory. [x] and [y] are coordinates to place the
  /// [text]. [font] is the name of font supported by printer.
  /// [mx] and [my] are used to multiply base font size to get desired size.
  /// [rotation] is the angle of rotation in degrees. allowed values are 0, 90, 180, 270
  /// [alignment] is the alignment of text. 0 & 1 Left, 2 Center, 3 Right
  /// [type] is the command type. TEXT or BLOCK
  Future text({
    required String text,
    required int x,
    required int y,
    required String font,
    int mx = 1,
    int my = 1,
    int rotation = 0,
    int alignment = 1,
    type = "TEXT",
  }) async {
    await sendCommand('$type $x, $y, "$font", $rotation, $mx , $my, $alignment, "$text" \r\n');
  }

  Future<void> printLabel(Map<String, dynamic> data) async {
    await init();

    int width = data['columns'] * data['width'];
    int offset = (data['width'] + data['columnGap']) * 8; // convert mm to dots
    int direction = data['reverseDirection'] ? 1 : 0;

    await sendCommand('SIZE $width mm,${data['height']} mm\r\n');
    await sendCommand('GAP ${data['rowGap']} mm,0 mm\r\n');
    await sendCommand('CLS\r\n');
    await sendCommand('CODEPAGE UTF-8\r\n');

    await sendCommand('DIRECTION $direction,0\r\n');
    await sendCommand('REFERENCE 0,0\r\n');

    for (var i = 0; i < data['columns']; i++) {
      if (!data['hideCompanyDetails']) {
        await text(
          text: data['companyName'],
          x: 200 + (offset * i),
          y: 10,
          font: fontTypes['largeBold']!,
          alignment: 2,
        );

        await text(text: data['companyAddress'], x: 200 + (offset * i), y: 35, font: fontTypes['small']!, alignment: 2);

        if (data['companyPhone'] != null && data['companyPhone'].isNotEmpty) {
          await text(
            text: '#: ${data['companyPhone']}',
            x: 200 + (offset * i),
            y: 50,
            font: fontTypes['small']!,
            alignment: 2,
          );
        }
      }

      if (data['productName'] != null && data['productName'].isNotEmpty) {
        await text(text: data['productName'], x: 200 + (offset * i), y: 75, font: fontTypes['bold']!, alignment: 2);
      }

      if (data['quantityType'] != 'None') {
        var unit = data['quantityType'] == 'Weight' ? data['unit'] : '';
        var quantity = '${data['quantityType']}: ${data['quantity']} $unit';

        await text(text: quantity, x: 40 + (offset * i), y: 100, font: fontTypes['normal']!);
      }

      await text(text: 'MRP: Rs. ${data['mrp']}', x: 40 + (offset * i), y: 120, font: fontTypes['normal']!);

      await text(text: 'MFG: ${data['mfgDate']}', x: 40 + (offset * i), y: 150, font: fontTypes['normal']!);

      if (data['showExpiryDate']) {
        await text(text: 'Expiry: ${data['expiryDate']}', x: 40 + (offset * i), y: 170, font: fontTypes['normal']!);
      } else if (data['showBestBefore']) {
        var bestBefore = 'Best before ${data['bestBefore']} ${data['bestBeforeUnit']}';

        await text(text: bestBefore, x: 40 + (offset * i), y: 170, font: fontTypes['normal']!);
      }

      if (!data['hideCompanyDetails'] && data['companyFssai'] != null && data['companyFssai'].isNotEmpty) {
        await text(
          text: 'FSSAI: ${data['companyFssai']}',
          x: 200 + (offset * i),
          y: 215,
          font: fontTypes['small']!,
          alignment: 2,
        );
      }
    }

    int copies = data['copies'] ?? 1;
    copies = (copies / data['columns']).ceil();

    await sendCommand('PRINT $copies\r\n');

    await UsbService.dispose();
  }
}

Map<String, String> fontTypes = {
  'tiny': 'A.FNT',
  'small': '1.EFT',
  'medium': '2.EFT',
  'bold': '3.EFT',
  'normal': 'D.FNT',
  'largeBold': '4.EFT',
};
