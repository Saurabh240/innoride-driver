import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/presentation/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/column_widget/card_column.dart';
import 'package:ovoride_driver/presentation/screens/ride_details/widgets/ride_review_bottom_sheet.dart';

class RideCompleteDetailsSection extends StatelessWidget {
  const RideCompleteDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideDetailsController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.ride.driverReview == null) ...[
            const SizedBox(height: Dimensions.space20),
            RoundedButton(
              text: MyStrings.review,
              isOutlined: false,
              isLoading: controller.isReviewLoading,
              press: () {
                CustomBottomSheet(
                  child: RideDetailsReviewBottomSheet(ride: controller.ride),
                ).customBottomSheet(context);
              },
              verticalPadding: 17,
              textColor: MyColor.colorWhite,
            ),
          ] else ...[
            if (controller.ride.userReview != null) ...[
              Text(
                'User Review',
                style: boldDefault.copyWith(
                    color: MyColor.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: MyColor.primaryColor),
              ),
              const SizedBox(height: Dimensions.space10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space10),
                decoration: BoxDecoration(
                    color: MyColor.greenSuccessColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(Dimensions.mediumRadius)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: CardColumn(
                            header: MyStrings.message,
                            body: (controller.ride.userReview?.review ?? '')
                                .toCapitalized())),
                    IntrinsicHeight(
                      child: Container(
                        width: 1,
                        color: MyColor.colorGrey.withValues(alpha: 0.5),
                        height: Dimensions.space25,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(MyStrings.ratting.tr,
                              style: regularSmall.copyWith(
                                  color: MyColor.getTextColor()
                                      .withValues(alpha: 0.6))),
                          const SizedBox(height: Dimensions.space5),
                          RatingBar.builder(
                            initialRating: StringConverter.formatDouble(
                                controller.ride.userReview?.rating ?? '1'),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemSize: 16,
                            onRatingUpdate: (v) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimensions.space30),
            ],
            Container(
              width: context.width,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColor.colorGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
              ),
              child: Center(
                child: Text(
                  MyStrings.rideCompleted.tr,
                  style: boldDefault.copyWith(color: MyColor.colorGrey),
                ),
              ),
            )
          ],
        ],
      );
    });
  }
}
