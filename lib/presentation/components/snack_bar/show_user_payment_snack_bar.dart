import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/image/my_local_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/drawer/drawer_user_info_card.dart';
import 'package:another_flushbar/flushbar.dart';

class CustomToast {
  static userPaymentNotify({
    required RideModel ride,
    required String currency,
    VoidCallback? reject,
    int duration = 15,
  }) {
    if (Get.context == null) {
      Get.rawSnackbar(
        progressIndicatorBackgroundColor: MyColor.transparentColor,
        progressIndicatorValueColor:
            const AlwaysStoppedAnimation<Color>(Colors.transparent),
        messageText: Column(
          children: [
            Text(
              'Payment Received Successfully',
              style: boldExtraLarge.copyWith(color: MyColor.greenSuccessColor),
              maxLines: 2,
            ),
            const SizedBox(height: Dimensions.space15),
            DrawerUserCard(
              fullName: '${ride.user?.firstname} ${ride.user?.lastname}',
              username: '${ride.user?.username}',
              subtitle: "",
              rightWidget: Text(
                "$currency${StringConverter.formatNumber(ride.amount ?? '')}",
                style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
              ),
              imgWidget: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.borderColor, width: 0.5),
                    shape: BoxShape.circle),
                height: 50,
                width: 50,
                child: const ClipOval(
                  child: MyLocalImageWidget(
                    imagePath: MyImages.defaultAvatar,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              imgHeight: 40,
              imgWidth: 40,
            ),
          ],
        ),
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.TOP,
        backgroundColor: MyColor.colorWhite,
        borderRadius: 4,
        margin: Get.isSnackbarOpen
            ? const EdgeInsets.only(top: Dimensions.space30)
            : const EdgeInsets.all(Dimensions.space10),
        padding: const EdgeInsets.all(Dimensions.space8),
        duration: Duration(seconds: duration),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeIn,
        showProgressIndicator: false,
        leftBarIndicatorColor: MyColor.greenP,
        animationDuration: const Duration(seconds: 1),
        borderColor: MyColor.transparentColor,
        reverseAnimationCurve: Curves.easeOut,
        borderWidth: 2,
      );
    } else {
      Flushbar(
        messageText: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Received Successfully',
              style: boldExtraLarge.copyWith(color: MyColor.greenSuccessColor),
              maxLines: 2,
            ),
            const SizedBox(height: Dimensions.space15),
            DrawerUserCard(
              fullName: '${ride.user?.firstname} ${ride.user?.lastname}',
              username: '${ride.user?.username}',
              subtitle: "",
              rightWidget: Text(
                "$currency${StringConverter.formatNumber(ride.amount ?? '')}",
                style: boldExtraLarge.copyWith(color: MyColor.primaryColor),
              ),
              imgWidget: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.borderColor, width: 0.5),
                    shape: BoxShape.circle),
                height: 50,
                width: 50,
                child: const ClipOval(
                  child: MyLocalImageWidget(
                    imagePath: MyImages.defaultAvatar,
                    boxFit: BoxFit.cover,
                  ),
                ),
              ),
              imgHeight: 40,
              imgWidth: 40,
            ),
          ],
        ),
        showProgressIndicator: false,
        margin: Get.isSnackbarOpen
            ? const EdgeInsets.only(top: Dimensions.space30)
            : const EdgeInsets.all(Dimensions.space10),
        borderRadius: BorderRadius.circular(Dimensions.cardRadius),
        backgroundColor: MyColor.colorWhite,
        duration: Duration(seconds: duration),
        leftBarIndicatorColor: MyColor.greenP,
        forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(Get.context!);
    }
  }
}
