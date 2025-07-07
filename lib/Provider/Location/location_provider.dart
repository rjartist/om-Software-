import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  String _userAddress = '';
  String get userAddress => _userAddress;
  static const String _addressKey = 'user_address';

  LocationProvider() {
    _loadAddressFromStorage();
  }

  Future<void> _loadAddressFromStorage() async {
    final storedAddress = SharedPrefHelper.getString(_addressKey);
    if (storedAddress != null && storedAddress.isNotEmpty) {
      _userAddress = storedAddress;
      notifyListeners();
    }
  }

  Future<void> fetchAndSaveLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    try {
      // Create platform-specific settings for location
      LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          // optionally add other Android settings here
        );
      } else if (Platform.isIOS || Platform.isMacOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          // optionally add other Apple settings here
        );
      } else {
        locationSettings = LocationSettings(accuracy: LocationAccuracy.high);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _userAddress = _formatAddress(place);

        await SharedPrefHelper.setString(_addressKey, _userAddress);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching location: $e');
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    // if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
    //   addressParts.add(place.subThoroughfare!); 
    // }

    // if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
    //   addressParts.add(place.thoroughfare!); // Street name
    // }

    // if (place.subLocality != null && place.subLocality!.isNotEmpty) {
    //   addressParts.add(place.subLocality!); // Colony or area
    // }

    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!); // City or town
    }

    // if (place.postalCode != null && place.postalCode!.isNotEmpty) {
    //   addressParts.add(place.postalCode!);
    // }

    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!); // State
    }

    // if (place.country != null && place.country!.isNotEmpty) {
    //   addressParts.add(place.country!);
    // }

    return addressParts.join(', ');
  }

  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> clearSavedAddress() async {
    await SharedPrefHelper.remove(_addressKey);
    _userAddress = '';
    notifyListeners();
  }

  Future<void> refreshAddress() async {
    await clearSavedAddress(); // Clears stored and in-memory address
    await fetchAndSaveLocation(); // Fetch new location and save it
  }

  void setCustomAddress(String address) async {
    _userAddress = address;
    await SharedPrefHelper.setString(_addressKey, address);
    notifyListeners();
  }
}
