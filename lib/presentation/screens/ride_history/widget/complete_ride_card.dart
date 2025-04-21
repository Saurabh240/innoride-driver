import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/ride_history/widget/ride_status_widget.dart';

import '../../../components/divider/custom_spacer.dart';
import '../../../components/timeline/custom_timeLine.dart';

class AllRideCard extends StatelessWidget {
  bool isPaymentDone;
  bool isReviewDone;
  RideModel ride;
  String currency;
  String imageUrl;
  VoidCallback reviewBtnCallback;

  AllRideCard({
    super.key,
    required this.isPaymentDone,
    required this.isReviewDone,
    required this.ride,
    required this.currency,
    required this.imageUrl,
    required this.reviewBtnCallback,
  });

  @override
  Widget build(BuildContext context) {
    printX(imageUrl);
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.rideDetailsScreen,
            arguments: ride.id.toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: MyColor.getCardBgColor(),
          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
          boxShadow: MyUtils.getCardShadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.space5,
                vertical: Dimensions.space5,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: MyColor.getCardBgColor(),
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
                boxShadow: MyUtils.getCardShadow(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            MyImageWidget(
                                imageUrl: imageUrl,
                                isProfile: true,
                                height: 45,
                                width: 45,
                                radius: 20),
                            const SizedBox(width: Dimensions.space10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${ride.user?.firstname} ${ride.user?.lastname}"
                                        .toTitleCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: boldMediumLarge,
                                  ),
                                  spaceDown(Dimensions.space5),
                                  FittedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${ride.duration}, ${ride.distance}km",
                                          style: boldDefault.copyWith(
                                              color: MyColor.primaryColor,
                                              fontSize: Dimensions.fontDefault,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      spaceSide(Dimensions.space10),
                      FittedBox(
                        child: Column(
                          children: [
                            RideStatusWidget(status: ride.status ?? ""),
                            SizedBox(height: 5),
                            Text(
                              "$currency${StringConverter.formatNumber(ride.amount ?? '0')}",
                              overflow: TextOverflow.ellipsis,
                              style: boldLarge.copyWith(
                                  fontSize: Dimensions.fontExtraLarge,
                                  fontWeight: FontWeight.w900,
                                  color: MyColor.rideTitle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceDown(Dimensions.space30),
                  SizedBox(
                    child: CustomTimeLine(
                      indicatorPosition: 0.1,
                      dashColor: MyColor.colorYellow,
                      firstWidget: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                MyStrings.pickUpLocation.tr,
                                style: boldLarge.copyWith(
                                    color: MyColor.rideTitle,
                                    fontSize: Dimensions.fontLarge - 1,
                                    fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            spaceDown(Dimensions.space5),
                            Text(
                              ride.pickupLocation ?? '',
                              style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            spaceDown(Dimensions.space8),
                            ride.startTime == "null"
                                ? SizedBox()
                                : Text(
                                    ride.startTime ?? '',
                                    style: regularDefault.copyWith(
                                      color: MyColor.getRideSubTitleColor(),
                                      fontSize: Dimensions.fontSmall,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            spaceDown(Dimensions.space15),
                          ],
                        ),
                      ),
                      secondWidget: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                MyStrings.destination.tr,
                                style: boldLarge.copyWith(
                                    color: MyColor.rideTitle,
                                    fontSize: Dimensions.fontLarge - 1,
                                    fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.space5 - 1,
                            ),
                            Text(
                              ride.destination ?? '',
                              style: regularDefault.copyWith(
                                color: MyColor.getRideSubTitleColor(),
                                fontSize: Dimensions.fontSmall,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            spaceDown(Dimensions.space8),
                            ride.endTime == "null"
                                ? SizedBox()
                                : Text(
                                    ride.endTime ?? '',
                                    style: regularDefault.copyWith(
                                      color: MyColor.getRideSubTitleColor(),
                                      fontSize: Dimensions.fontSmall,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
