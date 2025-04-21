import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/ride/new_ride/new_ride_controller.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/no_data.dart';
import 'package:ovoride_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:ovoride_driver/presentation/screens/rides/widget/new_ride_card.dart';

class NewRideSection extends StatefulWidget {
  final bool isInterCity;

  const NewRideSection({super.key, required this.isInterCity});

  @override
  State<NewRideSection> createState() => _NewRideSectionState();
}

class _NewRideSectionState extends State<NewRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<NewRideController>().hasNext()) {
        Get.find<NewRideController>().initialData(widget.isInterCity);
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller = Get.put(NewRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(widget.isInterCity);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRideController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.getNewRideList(p: 1, shouldLoading: true);
          },
          child: controller.isLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(10, (index) => const RideShimmer()),
                  ),
                )
              : controller.rideList.isEmpty && controller.isLoading == false
                  ? NoDataWidget(
                      isRide: true,
                      text: MyStrings.sorryThereIsNoNewRideFound.tr)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.space15),
                      itemCount: controller.rideList.length,
                      itemBuilder: (c, index) {
                        return NewRideCard(
                          currency: controller.defaultCurrencySymbol,
                          ride: controller.rideList[index],
                        );
                      },
                    ),
        );
      },
    );
  }
}
