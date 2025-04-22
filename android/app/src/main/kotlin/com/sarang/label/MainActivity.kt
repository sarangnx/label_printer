package com.sarang.label

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.sarang.label/usb"
    private val ACTION_USB_PERMISSION = "com.sarang.label.USB_PERMISSION"
    private lateinit var usbManager: UsbManager
    private var device: UsbDevice? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        usbManager = getSystemService(Context.USB_SERVICE) as UsbManager

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            if (call.method == "getUsbDevices") {
                val usbInfo = getConnectedUsbDevices()
                result.success(usbInfo)
            } else if (call.method == "requestUsbPermission") {
                val deviceId = call.argument<Int>("deviceId")
                if (deviceId != null) {
                    val permissionGranted = requestUsbPermission(deviceId)
                    result.success(permissionGranted)
                } else {
                    result.error("INVALID_ARGUMENT", "Device ID is required", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // get list of connected usb devices
    private fun getConnectedUsbDevices(): List<Map<String, Any>> {
        val deviceList: HashMap<String, UsbDevice> = usbManager.deviceList
        val devices = mutableListOf<Map<String, Any>>()

        if (deviceList.isEmpty()) {
            return emptyList()
        }

        for (device in deviceList.values) {
            devices.add(
                    mapOf(
                            "deviceName" to device.deviceName,
                            "deviceId" to device.deviceId,
                            "vendorId" to device.vendorId,
                            "productId" to device.productId,
                    )
            )
        }

        return devices
    }

    private fun requestUsbPermission(deviceId: Int): Boolean {
        val deviceList: HashMap<String, UsbDevice> = usbManager.deviceList

        // Find the device by its ID
        device = deviceList.values.find { it.deviceId == deviceId }
        if (device != null) {
            val permissionIntent =
                    PendingIntent.getBroadcast(
                            this,
                            0,
                            Intent(ACTION_USB_PERMISSION),
                            PendingIntent.FLAG_IMMUTABLE
                    )
            usbManager.requestPermission(device, permissionIntent)
            return true
        }
        return false
    }
}
