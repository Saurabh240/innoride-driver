import 'dart:typed_data';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/helper.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/environment.dart';

class RideMapController extends GetxController {
  bool isLoading = false;
  LatLng pickupLatLng = const LatLng(0, 0);
  LatLng destinationLatLng = const LatLng(0, 0);
  Map<PolylineId, Polyline> polylines = {};

  void loadMap({
    required LatLng pickup,
    required LatLng destination,
  }) async {
    pickupLatLng = pickup;
    destinationLatLng = destination;
    update();

    getPolylinePoints().then((data) {
      generatePolyLineFromPoints(data);
    });
    await setCustomMarkerIcon();
  }

  GoogleMapController? mapController;
  animateMapCameraPosition() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        zoom: Environment.mapDefaultZoom)));
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    isLoading = true;
    update();
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: MyColor.getPrimaryColor(),
        points: polylineCoordinates,
        width: 8);
    polylines[id] = polyline;
    isLoading = false;
    update();
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
          origin: PointLatLng(pickupLatLng.latitude, pickupLatLng.longitude),
          destination: PointLatLng(
              destinationLatLng.latitude, destinationLatLng.longitude),
          mode: TravelMode.driving),
      googleApiKey: Environment.mapKey,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      printX("result.errorMessage ${result.errorMessage}");
    }
    polylineCoordinates.map((e) {
      printX("e.toJson() ${e.toJson()}");
    });
    return polylineCoordinates;
  }

  Uint8List? pickupIcon;
  Uint8List? destinationIcon;

  Set<Marker> getMarkers(
      {required LatLng pickup, required LatLng destination}) {
    return {
      Marker(
        markerId: MarkerId('markerId${pickup.latitude}'),
        position: LatLng(pickup.latitude, pickup.longitude),
        icon: pickupIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(pickupIcon!,
                height: 40, width: 40, bitmapScaling: MapBitmapScaling.auto),
      ),
      Marker(
        markerId: MarkerId('markerId${destination.latitude}'),
        position: LatLng(destination.latitude, destination.longitude),
        icon: destinationIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(destinationIcon!,
                height: 45, width: 45, bitmapScaling: MapBitmapScaling.auto),
      ),
      Marker(
        markerId: MarkerId('markerId${destination.latitude}'),
        position: LatLng(pickupLatLng.latitude, pickupLatLng.longitude),
        icon: destinationIcon == null
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.bytes(destinationIcon!,
                height: 45, width: 45, bitmapScaling: MapBitmapScaling.auto),
      ),
    };
  }

  Future<void> setCustomMarkerIcon({bool? isRunning}) async {
    pickupIcon = await Helper.getBytesFromAsset(MyImages.pickUp, 80);
    destinationIcon = await Helper.getBytesFromAsset(MyImages.mapHome, 80);
    update();
  }
}
