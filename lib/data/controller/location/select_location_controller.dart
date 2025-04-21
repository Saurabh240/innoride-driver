import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/helper/string_format_helper.dart';
import '../../../core/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class SelectLocationController extends GetxController {
  Position? currentPosition;
  final currentAddress = "".obs;
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;

  bool isLoading = false;
  bool isLoadingFirstTime = false;
  TextEditingController searchLoactionController =
      TextEditingController(text: '');
  FocusNode searchFocus = FocusNode();

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      CustomSnackBar.error(errorList: [MyStrings.locationServiceDisableMsg]);
      return Future.value(false);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackBar.error(errorList: [MyStrings.locationPermissionDenied]);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      CustomSnackBar.error(
          errorList: [MyStrings.locationPermissionPermanentDenied]);
      return false;
    }

    return true;
  }

  int curPosCalled = 1;
  Future<void> getCurrentPosition({isLoading1stTime = false}) async {
    if (isLoading1stTime) {
      isLoadingFirstTime = true;
    } else {
      isLoadingFirstTime = false;
    }
    isLoading = true;

    update();

    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    if (currentPosition != null) {
      selectedLatitude = currentPosition!.latitude;
      selectedLongitude = currentPosition!.longitude;
      update();
    }

    animateMapCameraPosition();

    isLoading = false;
    isLoadingFirstTime = false;
    update();
  }

  Future<void> openMap(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude)
        .then((List<Placemark> placeMark) {
      Placemark placemark = placeMark[0];
      currentAddress.value =
          '${placemark.name}, ${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';

      searchLoactionController.text = currentAddress.value;
      update();
    }).catchError((e) {
      printX(e.toString());
    });
  }

  int cMI = 1;
  void changeCurrentLatLongBasedOnCameraMove(
      double selectedLatitude, double selectedLongitude) {
    this.selectedLatitude = selectedLatitude;
    this.selectedLongitude = selectedLongitude;

    update();
  }

  GoogleMapController? mapController;
  animateMapCameraPosition() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedLatitude, selectedLongitude), zoom: 18.0)));
  }

  Future<void> pickLocation() async {
    await openMap(selectedLatitude, selectedLongitude);
  }
}
