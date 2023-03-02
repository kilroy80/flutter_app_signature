package com.kino.flutter_app_signature

import android.content.Context
import android.content.pm.*
import android.os.Build
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import java.security.MessageDigest

/** FlutterAppSignaturePlugin */
class FlutterAppSignaturePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_app_signature")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "appSignature") {
      result.success(getAppSignature())
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  private fun getAppSignature(): ArrayList<String> {
    val signatureList: List<String>
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
        val signingInfo = context.packageManager
                .getPackageInfoCompat(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES).signingInfo
        signatureList = if (signingInfo.hasMultipleSigners()) {
          signingInfo.apkContentsSigners.map {
            val digest = MessageDigest.getInstance("SHA")
            digest.update(it.toByteArray())
            String(Base64.encode(digest.digest(), Base64.NO_WRAP))
          }
        } else {
          signingInfo.signingCertificateHistory.map {
            val digest = MessageDigest.getInstance("SHA")
            digest.update(it.toByteArray())
            String(Base64.encode(digest.digest(), Base64.NO_WRAP))
          }
        }
      } else {
        val sig = context.packageManager.getPackageInfo(
                context.packageName, PackageManager.GET_SIGNATURES).signatures
        signatureList = sig.map {
          val digest = MessageDigest.getInstance("SHA")
          digest.update(it.toByteArray())
          String(Base64.encode(digest.digest(), Base64.NO_WRAP))
        }
      }
      return ArrayList(signatureList)
    } catch (e: Exception) {
      Log.e("flutter app signature error : ", e.toString())
    }
    return ArrayList(emptyList())
  }

  private fun PackageManager.getPackageInfoCompat(packageName: String, flags: Int = 0): PackageInfo =
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getPackageInfo(context.packageName, PackageManager.PackageInfoFlags.of(flags.toLong()))
          } else {
            @Suppress("DEPRECATION") getPackageInfo(packageName, flags)
          }
}
