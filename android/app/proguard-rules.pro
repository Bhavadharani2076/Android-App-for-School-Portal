# Razorpay ProGuard Rules
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keep class com.razorpay.** { *; }

# Google Pay ProGuard Rules
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Optional: Keep all classes in your package (if needed)
# -keep class com.yourpackage.** { *; }

# Suppress warnings about missing classes for Google Pay and Razorpay
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.PaymentsClient
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.Wallet
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.WalletUtils
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
