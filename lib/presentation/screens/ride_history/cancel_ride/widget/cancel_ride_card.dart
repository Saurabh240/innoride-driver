import 'package:ovoride_driver/core/helper/date_converter.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/data/model/global/ride/ride_model.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/timeline/custom_timeLine.dart';

class CancelRideCard extends StatelessWidget {
  RideModel ride;
  String currency;
  CancelRideCard({
    super.key,
    required this.ride,
    required this.currency,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.only(bottom: 12),
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
              Text(
                MyStrings.rideCancel.tr,
                style: regularDefault.copyWith(fontSize: 16),
              ),
              Text(
                "$currency ${StringConverter.formatNumber(ride.amount ?? '0.0')}",
                style: boldLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MyColor.rideTitle),
              ),
            ],
          ),
          const SizedBox(
            height: Dimensions.space20,
          ),
          SizedBox(
            height: Dimensions.space50 + 80,
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
                  ],
                ),
              ),
            ),
          ),
          spaceDown(Dimensions.space10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MyColor.colorGrey2.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  MyStrings.rideCancel.tr,
                  style: boldDefault.copyWith(color: MyColor.colorGrey),
                ),
                Text(
                  DateConverter.estimatedDate(DateTime.now()),
                  style: boldDefault.copyWith(color: MyColor.colorGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 3;
    double dashSpace = 5;

    double startX = 0;

    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}
