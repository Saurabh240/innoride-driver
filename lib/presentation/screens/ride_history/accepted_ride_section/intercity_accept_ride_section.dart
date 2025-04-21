import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/controller/ride/accepted_ride/intercity_accepted_ride_controller.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/no_data.dart';
import 'package:ovoride_driver/presentation/components/shimmer/ride_shimmer.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/accepted_ride_section/accepted_ride_card.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/widget/cancel_bottom_sheet.dart';

class IntercityAcceptedRideSection extends StatefulWidget {
  const IntercityAcceptedRideSection({super.key});

  @override
  State<IntercityAcceptedRideSection> createState() =>
      _IntercityAcceptedRideSectionState();
}

class _IntercityAcceptedRideSectionState
    extends State<IntercityAcceptedRideSection> {
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<IntercityAcceptedRideController>().hasNext()) {
        Get.find<IntercityAcceptedRideController>().getAcceptedRideList();
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    final controller =
        Get.put(IntercityAcceptedRideController(repo: Get.find()));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntercityAcceptedRideController>(builder: (controller) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.getAcceptedRideList(p: 1, shouldLoading: true);
        },
        child: controller.isLoading
            ? SingleChildScrollView(
                child: Column(
                    children:
                        List.generate(10, (index) => const RideShimmer())),
              )
            : controller.isLoading == false && controller.rideList.isEmpty
                ? const NoDataWidget(
                    isRide: true,
                    text: MyStrings.sorryThereIsNoPendingRideFound)
                : ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space15),
                    itemCount: controller.rideList.length,
                    itemBuilder: (context, index) {
                      return AcceptedRideCard(
                        isActive: false,
                        currency: controller.defaultCurrencySymbol,
                        ride: controller.rideList[index],
                        imageUrl:
                            '${UrlContainer.domainUrl}/${controller.imagePath}/${controller.rideList[index].user?.avatar}',
                        cancelCallback: () {
                          CustomBottomSheet(
                            child: CancelBottomSheet(
                                ride: controller.rideList[index]),
                          ).customBottomSheet(context);
                        },
                      );
                    },
                  ),
      );
    });
  }
}
