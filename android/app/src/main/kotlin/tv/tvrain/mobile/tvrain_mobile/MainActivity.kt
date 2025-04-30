package com.example.dynamic_icon_native_approach

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.dynamic_icon_native_approach/AppIconManager"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "switchAppIcon") {
                val iconName = call.argument<String>("iconName")
                val success = switchAppIcon(iconName)
                result.success(success)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun switchAppIcon(iconName: String?): Boolean {
        return try {
            val packageManager = applicationContext.packageManager
            val packageName = applicationContext.packageName

            // First handle main activity
            val mainActivity = ComponentName(packageName, "$packageName.MainActivity")

            // Handle activity aliases
            val mainIconAlias = ComponentName(packageName, "$packageName.MainIconActivity")
            val altIconAlias = ComponentName(packageName, "$packageName.AlternativeIconActivity")

            when (iconName) {
                "main" -> {
                    // For main icon, we'll use the MainActivity's default icon
                    packageManager.setComponentEnabledSetting(
                        mainActivity,
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP
                    )

                    // Disable the activity aliases
                    packageManager.setComponentEnabledSetting(
                        mainIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        altIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
                "alternative" -> {
                    // For alternative icon, disable MainActivity and main icon alias
                    packageManager.setComponentEnabledSetting(
                        mainActivity,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        mainIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )

                    // Enable alternative icon alias
                    packageManager.setComponentEnabledSetting(
                        altIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
                else -> {
                    // Default to main icon
                    packageManager.setComponentEnabledSetting(
                        mainActivity,
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        mainIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                    packageManager.setComponentEnabledSetting(
                        altIconAlias,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP
                    )
                }
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
