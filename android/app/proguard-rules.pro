# Razorpay required rules
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# Fix for missing annotations used internally by Razorpay
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
