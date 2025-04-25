package com.sarang.label

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbInterface
import android.hardware.usb.UsbManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.sarang.label/usb"
    private val ACTION_USB_PERMISSION = "com.sarang.label.USB_PERMISSION"
    private lateinit var usbManager: UsbManager
    private var device: UsbDevice? = null
    private var connection: UsbDeviceConnection? = null
    private var usbInterface: UsbInterface? = null
    private var usbEndpoint: UsbEndpoint? = null
    private var usbEndpointReceiver: UsbEndpoint? = null

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
            } else if (call.method == "writeData") {
                val data = call.argument<ByteArray>("data")
                if (data != null && device != null) {
                    val success = writeData(data)
                    result.success(success)
                } else {
                    result.error("INVALID_ARGUMENT", "Data or device is missing", null)
                }
            } else if (call.method == "openConnection") {
                val success = openConnection()
                result.success(success)
            } else if (call.method == "dispose") {
                dispose()
                result.success(null)
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

    private fun openConnection(): Boolean {
        if (device == null) {
            return false
        }

        connection = usbManager.openDevice(device)

        if (connection == null) {
            return false
        }

        usbInterface = device!!.getInterface(0)

        if (usbInterface == null || !connection!!.claimInterface(usbInterface, true)) {
            return false
        }

        for (i in 0 until usbInterface!!.endpointCount) {
            val endpoint = usbInterface!!.getEndpoint(i)
            if (endpoint.type == UsbConstants.USB_ENDPOINT_XFER_BULK) {
                if (endpoint.direction == UsbConstants.USB_DIR_OUT) {
                    usbEndpoint = endpoint
                } else if (endpoint.direction == UsbConstants.USB_DIR_IN) {
                    usbEndpointReceiver = endpoint
                }
            }
        }

        if (usbEndpoint == null) {
            return false
        }

        return true
    }

    private fun dispose() {
        if (connection != null) {
            if (usbInterface != null) {
                connection!!.releaseInterface(usbInterface)
                usbInterface = null
            }
            connection!!.close()
            connection = null
        }
        device = null
        usbEndpoint = null
        usbEndpointReceiver = null
    }

    private fun writeData(data: ByteArray): Any {
        if (device == null || connection == null || usbEndpoint == null) {
            print("Device, connection, or endpoint is null")
            return 0
        }

        val bytesWritten = connection!!.bulkTransfer(usbEndpoint, data, data.size, 0)

        return bytesWritten
    }
}
