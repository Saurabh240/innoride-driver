import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/ride/cancel_ride/cancel_ride_controller.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/no_data.dart';
import 'package:ovoride_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/cancel_ride/widget/cancel_ride_card.dart';

import '../../../../core/utils/dimensions.dart';

class CancelRideSection extends StatefulWidget {
  final bool isInterCity;

  const CancelRideSection({super.key, required this.isInterCity});

  @override
  State<CancelRideSection> createState() => _CancelRideSectionState();
}

class _CancelRideSectionState extends State<CancelRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<CancelRideController>().hasNext()) {
        Get.find<CancelRideController>().getCanceledRideList();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(CancelRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(widget.isInterCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CancelRideController>(
      builder: (controller) {
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            controller.initialData(widget.isInterCity);
          },
          backgroundColor: MyColor.primaryColor,
          color: MyColor.colorWhite,
          child: controller.isLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(10, (index) => const RideShimmer()),
                  ),
                )
              : controller.isLoading == false &&
                      controller.cancelRideList.isEmpty
                  ? NoDataWidget(
                      isRide: true,
                      text: MyStrings.sorryThereIsNoCanceledRideFound.tr,
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space15,
                      ),
                      itemCount: controller.cancelRideList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: CancelRideCard(
                            ride: controller.cancelRideList[index],
                            currency: controller.defaultCurrencySymbol,
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
