import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/dashboard/dashboard_controller.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/accepted_ride_section/accepted_ride_card.dart';
import 'package:ovoride_driver/presentation/screens/rides/new_rides/widget/running_ride_warning_section.dart';

class PendingRideList extends StatelessWidget {
  final DashBoardController controller;
  const PendingRideList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.runningRide?.id == "-1"
            ? const SizedBox.shrink()
            : const RunningRideWarning(),
        if (controller.pendingRidesList.isNotEmpty) ...[
          Text(MyStrings.pendingRides.tr, style: boldLarge.copyWith()),
          const SizedBox(height: Dimensions.space10),
          Column(
            children: List.generate(
              controller.pendingRidesList.length,
              (index) {
                return AcceptedRideCard(
                  isActive: true,
                  ride: controller.pendingRidesList[index],
                  currency: controller.currencySym,
                  imageUrl: '',
                  cancelCallback: () {},
                );
              },
            ),
          )
        ],
      ],
    );
  }
}
