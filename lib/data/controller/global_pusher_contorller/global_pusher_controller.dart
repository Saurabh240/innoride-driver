import 'dart:convert';

import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/audio_utils.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovoride_driver/data/model/global/pusher/pusher_event_response_model.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/dialog/custom_new_ride_dialog.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../core/helper/shared_preference_helper.dart';
import '../../../core/helper/string_format_helper.dart';
import '../../../core/utils/url_container.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../model/general_setting/general_setting_response_model.dart';
import '../../services/api_service.dart';
import 'package:http/http.dart' as http;

class GlobalPusherController extends GetxController {
  ApiClient apiClient;
  DashBoardController dashBoardController;

  GlobalPusherController(
      {required this.apiClient, required this.dashBoardController});

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  bool isPusherLoading = false;
  String appKey = '';
  String cluster = '';
  String token = '';
  String userId = '';

  PusherConfig pusherConfig = PusherConfig();

  void subscribePusher({required String driverId}) async {
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
    configure("private-new-ride-for-driver-$driverId");

    isPusherLoading = false;
    update();
  }

  Future<void> configure(String channelName) async {
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

    await pusher.subscribe(channelName: channelName);
    await pusher.connect();
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
        printX("global pusher auth success");

        Map<String, dynamic> json = jsonDecode(result.body);
        return json;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void onConnectionStateChange(
      dynamic currentState, dynamic previousState) async {
    printX("on connection state change $previousState $currentState");
  }

  void onEvent(PusherEvent event) {
    if (event.eventName == "driver-new-ride") {
      AudioUtils.playAudio(apiClient.getNotificationAudio());
      PusherResponseModel model =
          PusherResponseModel.fromJson(jsonDecode(event.data));
      final pusherData = PusherResponseModel(
          eventName: event.eventName,
          channelName: event.channelName,
          data: model.data);

      dashBoardController.updateMainAmount(
          double.tryParse(pusherData.data?.ride?.amount.toString() ?? "0.00") ??
              0);
      CustomNewRideDialog.newRide(
        ride: pusherData.data?.ride ?? RideModel(id: "-1"),
        currency: Get.find<ApiClient>().getCurrencyOrUsername(),
        currencySym:
            Get.find<ApiClient>().getCurrencyOrUsername(isSymbol: true),
        dashboardController: dashBoardController,
        onBidClick: () {
          var ride = pusherData.data?.ride;
          double enterValue =
              double.tryParse(dashBoardController.amountController.text) ?? 0.0;
          if (enterValue.toPrecision(0) >=
                  (double.tryParse(ride?.minAmount.toString() ?? "0.00") ??
                      0) &&
              (enterValue.toPrecision(0)) <
                  (double.tryParse(ride?.maxAmount.toString() ?? "0.00") ??
                      0)) {
            dashBoardController.sendBid(pusherData.data?.ride?.id ?? '-1');
          } else {
            CustomSnackBar.error(
              errorList: [
                '${MyStrings.pleaseEnterMinimum} ${dashBoardController.currencySym}${StringConverter.formatNumber(ride?.minAmount ?? '0')} to ${dashBoardController.currencySym}${StringConverter.formatNumber(ride?.maxAmount ?? '')}'
              ],
            );
          }
        },
      );

      dashBoardController.loadData();
      dashBoardController.update();
    }

    if (event.eventName == "bid_accept") {
      PusherResponseModel model =
          PusherResponseModel.fromJson(jsonDecode(event.data));
      final pusherData = PusherResponseModel(
          eventName: event.eventName,
          channelName: event.channelName,
          data: model.data);

      Get.toNamed(RouteHelper.rideDetailsScreen,
          arguments: pusherData.data?.ride?.id);
    }
  }

  void onError(String message, int? code, dynamic e) {
    printX("onError: $message");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {}

  void onSubscriptionError(String message, dynamic e) {
    printX("onSubscription Error: $message");
  }
}
