package dev.recyclo.game

import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.pay.Pay
import com.google.android.gms.pay.PayApiAvailabilityStatus
import com.google.android.gms.pay.PayClient
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import android.content.Intent
import android.util.Log
import android.view.View

class MainActivity: FlutterActivity() {

    private val addToGoogleWalletRequestCode = 1000

    private lateinit var walletClient: PayClient
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        walletClient = Pay.getClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "REQUEST_WALLET").setMethodCallHandler {
                call, result ->
            if (call.method == "ADD_TO_WALLET") {
                val jwtToken = call.argument<String>("jwt")!!
                walletClient
                    .getPayApiAvailabilityStatus(PayClient.RequestType.SAVE_PASSES)
                    .addOnSuccessListener { status ->
                        if (status == PayApiAvailabilityStatus.AVAILABLE)
                            Log.e("SavePassesResult", "AVAILABLE")
                        else
                            Log.e("SavePassesResult", "NOT AVAILABLE")
                    }
                    .addOnFailureListener {
                        Log.e("SavePassesResult", "FAILURE")
                    }
                Log.e("SavePassesResult", jwtToken)
                walletClient.savePassesJwt(jwtToken, this, addToGoogleWalletRequestCode)
                result.success("REQUEST_SUCCESS")
            }
            else if (call.method == "VIEW_IN_WALLET") {
                val packageManager = this.packageManager
                val launchIntent = packageManager.getLaunchIntentForPackage("com.google.android.apps.walletnfcrel")
                startActivity(launchIntent)
                result.success("REQUEST_SUCCESS")
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == addToGoogleWalletRequestCode) {
            when (resultCode) {
                RESULT_OK -> {
                    // Pass saved successfully. Consider informing the user.
                }

                RESULT_CANCELED -> {
                    // Save canceled
                }

                PayClient.SavePassesResult.SAVE_ERROR ->
                    data?.let { intentData ->
                        val errorMessage = intentData.getStringExtra(PayClient.EXTRA_API_ERROR_MESSAGE)
                        // Handle error. Consider informing the user.
                        Log.e("SavePassesResult", errorMessage.toString())
                    }

                PayClient.SavePassesResult.INTERNAL_ERROR ->
                    data?.let { intentData ->
                        val errorMessage = intentData.getStringExtra(PayClient.EXTRA_API_ERROR_MESSAGE)
                        // Handle error. Consider informing the user.
                        Log.e("SavePassesResult", errorMessage.toString())
                    }

                else -> {
                    Log.e("SavePassesResult","Unknown Error $resultCode")
                }
            }
        }
    }
}
