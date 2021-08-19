package com.nyartech.hyperpay

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.Uri
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.oppwa.mobile.connect.exception.PaymentError
import com.oppwa.mobile.connect.exception.PaymentException
import com.oppwa.mobile.connect.payment.PaymentParams
import com.oppwa.mobile.connect.payment.card.CardPaymentParams
import com.oppwa.mobile.connect.provider.Connect
import com.oppwa.mobile.connect.provider.ITransactionListener
import com.oppwa.mobile.connect.provider.Transaction
import com.oppwa.mobile.connect.provider.TransactionType
import com.oppwa.mobile.connect.service.ConnectService
import com.oppwa.mobile.connect.service.IProviderBinder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HyperpayPlugin */
class HyperpayPlugin : FlutterPlugin, MethodCallHandler, ITransactionListener, ActivityAware {
    private val TAG = "HyperpayPlugin"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var channelResult: MethodChannel.Result? = null

    private lateinit var mActivity: Activity

    private var providerBinder: IProviderBinder? = null
    private lateinit var intent: Intent

    // Get the checkout ID from the endpoint on your server
    private var checkoutID = ""

    private var paymentMode = ""

    // Card details
    private var brand = Brand.UNKNOWN
    private var cardHolder: String = ""
    private var cardNumber: String = ""
    private var expiryMonth: String = ""
    private var expiryYear: String = ""
    private var cvv: String = ""

    private var shopperResultUrl: String = ""

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hyperpay")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity;

        // Remove any underscores from the application ID for Uri parsing
        // NOTE: It's important to add your application ID as the scheme, followed by ".payments"
        // without any underscores.
        shopperResultUrl = mActivity.packageName.replace("_", "")
        shopperResultUrl += ".payments"

        binding.addOnNewIntentListener {
            if (it.scheme == shopperResultUrl) {
                success("Success: asynchronous 🎉")
            }

            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        mActivity.stopService(intent)
        mActivity.unbindService(serviceConnection)
    }

    // Handling result options
    private val handler: Handler = Handler(Looper.getMainLooper())

    private fun success(result: Any?) {
        handler.post { channelResult!!.success(result) }
    }

    private fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
        handler.post { channelResult!!.error(errorCode, errorMessage, errorDetails) }
    }

    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {

            Log.d(TAG, "Hyperpay service is connected, start listening...")

            providerBinder = service as IProviderBinder
            providerBinder!!.addTransactionListener(this@HyperpayPlugin)

            if (paymentMode == "LIVE") {
                providerBinder!!.initializeProvider(Connect.ProviderMode.LIVE);
            } else {
                providerBinder!!.initializeProvider(Connect.ProviderMode.TEST);
            }
        }

        override fun onServiceDisconnected(name: ComponentName) {
            providerBinder!!.removeTransactionListener(this@HyperpayPlugin)
            providerBinder = null
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "setup_service" -> {
                try {
                    val args: Map<String, Any> = call.arguments as Map<String, Any>

                    paymentMode = args["mode"] as String

                    // Initialize an application intent to attach to HyperPay service
                    intent = Intent(mActivity.applicationContext, ConnectService::class.java)

                    // Start and bind with the intent
                    mActivity.startService(intent)
                    mActivity.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)

                    Log.d(TAG, "Payment mode is set to $paymentMode")
                    result.success(null)
                } catch (e: java.lang.Exception) {
                    e.printStackTrace()

                    result.error("", e.message, e.stackTrace)
                }
            }
            "start_payment_transaction" -> {
                channelResult = result

                val args: Map<String, Any> = call.arguments as Map<String, Any>
                checkoutID = (args["checkoutID"] as String?)!!
                brand = Brand.valueOf(args["brand"].toString())

                val card: Map<String, Any> = args["card"] as Map<String, Any>
                cardHolder = (card["holder"] as String?)!!
                cardNumber = (card["number"] as String?)!!
                expiryMonth = (card["expiryMonth"] as String?)!!
                expiryYear = (card["expiryYear"] as String?)!!
                cvv = (card["cvv"] as String?)!!

                when (brand) {
                    // If the brand is not provided it returns an error result
                    Brand.UNKNOWN -> result.error(
                        "0.1",
                        "Please provide a valid brand",
                        ""
                    )
                    else -> {
                        checkCreditCardValid()

                        val paymentParams: PaymentParams = CardPaymentParams(
                            checkoutID,
                            brand.name,
                            cardNumber,
                            cardHolder,
                            expiryMonth,
                            expiryYear,
                            cvv
                        )

                        // Set shopper result URL
                        paymentParams.shopperResultUrl = "$shopperResultUrl://result"

                        try {
                            val transaction = Transaction(paymentParams)
                            providerBinder?.submitTransaction(transaction)
                        } catch (e: PaymentException) {
                            result.error(
                                "0.3",
                                e.localizedMessage,
                                ""
                            )
                        }
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * This function checks the provided card params and return
     * a PlatformException to Flutter if any are not valid.
     * */
    private fun checkCreditCardValid() {
        if (!CardPaymentParams.isNumberValid(cardNumber)) {
            error(
                "1.1",
                "Card number is not valid for brand ${brand.name}",
                ""
            )
        } else if (!CardPaymentParams.isHolderValid(cardHolder)) {
            error(
                "1.2",
                "Holder name is not valid",
                ""
            )
        } else if (!CardPaymentParams.isExpiryMonthValid(expiryMonth)) {
            error(
                "1.3",
                "Expiry month is not valid",
                ""
            )
        } else if (!CardPaymentParams.isExpiryYearValid(expiryYear)) {
            error(
                "1.4",
                "Expiry year is not valid",
                ""
            )
        } else if (!CardPaymentParams.isCvvValid(cvv)) {
            error(
                "1.5",
                "CVV is not valid",
                ""
            )
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun transactionCompleted(transaction: Transaction) {
        try {
            if (transaction.transactionType == TransactionType.SYNC) {
                // Send request to your server to obtain transaction status
                success("Transaction completed as synchronous.")
            } else {
                val uri = Uri.parse(transaction.redirectUrl)
                val intent = Intent(Intent.ACTION_VIEW, uri)
                mActivity.startActivity(intent)
            }
        } catch (e: Exception) {
            e.printStackTrace()

            // Display error
            error("${e.message}️")
        }
    }

    override fun transactionFailed(transaction: Transaction, error: PaymentError) {
        error(
            "${error.errorCode}",
            error.errorMessage,
            "${error.errorInfo}"
        )
    }
}