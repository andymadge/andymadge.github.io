---
title: Create a QR Code for connecting to Wifi
header:
  image: assets/images/header-images/IMG_8424_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - wifi
---
This should work with iOS 11+ and recent Android versions.

Simply open the phone camera and point at the QR Code.  A message should pop up asking if you want to connect to Wifi.

The actual text encoded in the QR code for a Wifi connection is...

```
WIfI:S:<SSID>;T:<WPA|WEP|>;P:<password>;;
```

Detailed description at <https://github.com/zxing/zxing/wiki/Barcode-Contents#wifi-network-config-android>

This can be used by ANY QR code generator, such as in Brother P-Touch label printer.

Examples:

```
WIFI:S:MyWifi;T:WPA;P:mywifipasscode;;
```

Online QR Code Generators
* <https://qifi.org/>
    * Clean and easy to use
    * Doesn't generate the raw text for you, but does link to the above spec page telling you how to generate the text manually
* <http://zxing.appspot.com/generator/>
    * Clean and easy to use
    * More features
    * Shows the raw text
* Other generators with different features:
    * <https://www.qrstuff.com/>
    * <http://blog.qr4.nl/QR-Code-WiFi.aspx>

Useful info
* <https://9to5mac.com/2017/06/12/top-10-qr-codes-supported-by-ios-11/> describes several types of QR code supported by ios 11
* <https://9to5mac.com/2017/06/06/ios-11-share-your-wifi/> not about QR codes, but describes another useful Wifi-related feature in iOS 11
