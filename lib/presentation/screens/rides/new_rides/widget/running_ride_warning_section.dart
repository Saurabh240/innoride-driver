import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';

class RunningRideWarning extends StatelessWidget {
  const RunningRideWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      builder: (controller) {
        return InkWell(
          onTap: () {
            Get.toNamed(RouteHelper.rideDetailsScreen,
                arguments: controller.runningRide?.id ?? '-1');
          },
          child: Card(
            color: MyColor.colorWhite,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: Dimensions.space15,
                  right: Dimensions.space15,
                  top: 0,
                  bottom: Dimensions.space1),
              padding: const EdgeInsets.symmetric(
                  horizontal: 0, vertical: Dimensions.space10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStrings.checkRunningRide.tr,
                    style:
                        boldDefault.copyWith(color: MyColor.greenSuccessColor),
                  ),
                  const SizedBox(height: Dimensions.space4),
                  Text(
                    MyStrings.runningRideMessage.tr,
                    style: regularSmall.copyWith(color: MyColor.colorBlack),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
