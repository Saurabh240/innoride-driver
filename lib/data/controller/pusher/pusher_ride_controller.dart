import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ovoride_driver/core/helper/shared_preference_helper.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:ovoride_driver/data/model/general_setting/general_setting_response_model.dart';
import 'package:ovoride_driver/data/model/global/app/message_response_model.dart';
import 'package:ovoride_driver/data/model/global/app/ride_meassage_model.dart';
import 'package:ovoride_driver/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class PusherRideController extends GetxController {
  ApiClient apiClient;
  RideMessageController controller;
  RideDetailsController detailsController;
  PusherRideController({
    required this.apiClient,
    required this.controller,
    required this.detailsController,
  });

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  late PusherChannel channel;
  bool isPusherLoading = false;
  String appKey = '';
  String cluster = '';
  String token = '';
  String userId = '';
  String rideId = '';

  PusherConfig pusherConfig = PusherConfig();

  String driverId = "";

  void subscribePusher({required String rideId}) async {
    driverId = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userIdKey) ??
        "-1";
    rideId = rideId;
    isPusherLoading = true;
    pusherConfig = apiClient.getPushConfig();
    appKey = pusherConfig.appKey ?? '';
    cluster = pusherConfig.cluster ?? '';
    token = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.accessTokenKey) ??
        '';
    userId = apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userIdKey) ??
        '';
    update();
    printX('appKey ${pusherConfig.toJson()}');
    printX('appKey $appKey');
    printX('appKey $cluster');

    configure("private-ride-$rideId");

    isPusherLoading = false;
    update();
  }

  Future<void> configure(String channelName) async {
    try {
      printX('appKey $appKey');
      printX('appKey $cluster');
      await pusher.init(
        apiKey: appKey,
        cluster: cluster,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onConnectionStateChange: onConnectionStateChange,
        onMemberAdded: (channelName, member) {},
        onAuthorizer: onAuthorizer,
      );

      //  channel = await pusher.subscribe(channelName: channelName);
      await pusher.subscribe(channelName: channelName);
      await pusher.connect();
    } catch (e) {
      printX('error $e');
    }
  }

  Future<Map<String, dynamic>?> onAuthorizer(
      String channelName, String socketId, options) async {
    try {
      String authUrl =
          "${UrlContainer.baseUrl}${UrlContainer.pusherAuthenticate}$socketId/$channelName";
      http.Response result = await http.post(
        Uri.parse(authUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          "dev-token":
              "\$2y\$12\$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG",
        },
      );
      if (result.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(result.body);
        return json;
      } else {
        return null;
      }
    } catch (e) {
      printX('Autherror: $e');
      return null;
    }
  }

  void onConnectionStateChange(
      dynamic currentState, dynamic previousState) async {
    printX("on connection state change $previousState $currentState");
  }

  void onEvent(PusherEvent event) {
    printX('event.data ${event.eventName}');
    if (event.eventName == "message-received") {
      printX(Get.currentRoute);
      if (Get.currentRoute == RouteHelper.rideDetailsScreen) {
        MyUtils.vibrate();
      }
      MessageResponseModel model =
          MessageResponseModel.fromJson(jsonDecode(event.data));
      controller.addEventMessage(
        RideMessage(
            rideId: model.data?.message?.rideId ?? '-1',
            message: model.data?.message?.message,
            driverId: model.data?.message?.driverId,
            userId: model.data?.message?.userId,
            image: model.data?.message?.image),
      );
    }

    PusherResponseModel model =
        PusherResponseModel.fromJson(jsonDecode(event.data));
    printX('event.channelName ${event.eventName}');
    final modify = PusherResponseModel(
        eventName: event.eventName,
        channelName: event.channelName,
        data: model.data);

    if (event.eventName.toLowerCase().trim() ==
        "cash-payment-request".toLowerCase().trim()) {
      printX('payment_complete from payment_complete');
      detailsController.onShowPaymentDialog(Get.context!);
    }
    //  else if (event.eventName.toLowerCase().trim() == "".toLowerCase().trim()) {
    //   // Get.offAllNamed(RouteHelper.allRideScreen);
    //   if (event.data?.ride != null) {
    //     detailsController.changeCashPaymentRequest(false);
    //     detailsController.updateRide(event.data!.ride!);
    //   }

    //   CustomSnackBar.success(successList: ["Ride Completed Successfully"]);
    // }
    else {
      updateEvent(modify);
    }
  }

  void onError(String message, int? code, dynamic e) {
    printX("onError: $message");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {}

  void onSubscriptionError(String message, dynamic e) {
    printX("onSubscription Error: $message");
  }

  triggerEvent() async {
    try {
      await MyUtils.getCurrentLocation().then((v) {
        channel.trigger(
          PusherEvent(
            channelName: "private-ride-$rideId", // Must match subscription
            eventName: 'client-live_location',
            data: jsonEncode({
              'latitude': v.latitude.toString(),
              'longitude': v.longitude.toString(),
              'driverId': detailsController.ride.id ?? '',
              'userId': userId,
              'rideId': controller.rideId,
            }),
          ),
        );
      });
    } catch (e) {
      printX("Error triggering event: $e");
    }
  }

  //----------Pusher Response ----------------------

  updateEvent(PusherResponseModel event) {
    printX('event.eventName ${event.eventName}');
    if (event.eventName == "pick_up" ||
        event.eventName == "ride_end" ||
        event.eventName == "online-payment-received") {
      if (event.eventName == "online-payment-received") {
        CustomSnackBar.success(successList: ["Payment Received"]);
      }
      if (event.data?.ride != null) {
        detailsController.updateRide(event.data!.ride!);
      }
    }
  }

  void clearData() {
    closePusher();
  }

  void closePusher() async {
    await pusher.unsubscribe(
        channelName: "private-ovoride_ride_${detailsController.ride.id}");
    await pusher.disconnect();
  }
}
