import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  Position _currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  String _currentAddress = "Loading...";
  PermissionStatus _status = PermissionStatus.denied;

  String get currentAddress => _currentAddress;
  Position get currentPosition => _currentPosition;
  PermissionStatus get status => _status;

// Setters
  set currentAddress(String address) {
    _currentAddress = address;
  }

  set currentPosition(Position position) {
    _currentPosition = position;
  }

 /* Future<void> init() async {
    printX('status>>init');
    _status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request().then((value) async {
        _status = value;
        await getCurrentLocation();
      }).onError((error, stackTrace) {
        CustomSnackBar.error(
            errorList: ["Please enable your location permission"]);
      });
    } else {
      await getCurrentLocation();
    }
    printX('status>>$status');
  }
*/
  Future<void> init() async {
    printX('status>>init');

    _status = await Permission.location.status;

    if (_status.isGranted) {
      await getCurrentLocation();
    } else if (_status.isDenied) {
      // Request permission
      final result = await Permission.location.request();
      _status = result;

      if (_status.isGranted) {
        await getCurrentLocation();
      } else if (_status.isPermanentlyDenied) {
        CustomSnackBar.error(
            errorList: ["Location permission is permanently denied. Please enable it in settings."]);
        await openAppSettings();
      } else {
        CustomSnackBar.error(
            errorList: ["Location permission was denied. Please enable it."]);
      }
    } else if (_status.isPermanentlyDenied) {
      CustomSnackBar.error(
          errorList: ["Location permission is permanently denied. Please enable it in settings."]);
      await openAppSettings();
    }

    printX('status>>$_status');
  }

  Future<void> getCurrentLocation() async {
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
      _currentPosition = await geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.best));
      final List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      // _currentAddress = "";
      _currentAddress =
          "${placemarks[0].street} ${placemarks[0].subThoroughfare} ${placemarks[0].thoroughfare},${placemarks[0].subLocality},${placemarks[0].locality},${placemarks[0].country}";
    } catch (e) {
      printX("Error>>>>>>>: $e");
      CustomSnackBar.error(
          errorList: ["Something went wrong while Taking Location"]);
    }
    printX('status>>$currentAddress');
    printX('status>>${currentPosition.latitude} ${currentPosition.latitude}');
  }
}
