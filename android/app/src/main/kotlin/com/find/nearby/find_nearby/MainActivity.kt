package com.find.nearby.find_nearby

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "find_nearby/whatsapp")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "installed" -> result.success(installedWhatsApp())
                    "open" -> {
                        val phone = call.argument<String>("phone").orEmpty()
                        val packageName = call.argument<String>("package")
                        result.success(openWhatsApp(phone, packageName))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun installedWhatsApp(): List<String> {
        val pm = applicationContext.packageManager
        return listOf("com.whatsapp", "com.whatsapp.w4b").filter { id ->
            runCatching { pm.getPackageInfo(id, 0) }.isSuccess
        }
    }

    private fun openWhatsApp(phone: String, packageName: String?): Boolean {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("whatsapp://send?phone=$phone"))
        if (packageName != null) intent.setPackage(packageName)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return runCatching {
            startActivity(intent)
            true
        }.getOrDefault(false)
    }
}
