import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/review/review_controller.dart';
import 'package:ovoride_driver/data/repo/review/review_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_spacer.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/review/widget/user_review_list.dart';

class UserReviewHistory extends StatefulWidget {
  const UserReviewHistory({super.key});

  @override
  State<UserReviewHistory> createState() => _UserReviewHistoryState();
}

class _UserReviewHistoryState extends State<UserReviewHistory> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ReviewRepo(apiClient: Get.find()));
    final controller = Get.put(ReviewController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (Get.arguments != null) {
        controller.getReviewByUserId(Get.arguments.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorWhite,
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.space15,
                  right: Dimensions.space15,
                  top: Dimensions.space15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          splashColor:
                              MyColor.primaryColor.withValues(alpha: 0.01),
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space10),
                            decoration: BoxDecoration(
                                color: MyColor.primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: MyColor.colorWhite, size: 20),
                          ),
                        ),
                        SizedBox(width: Dimensions.space10),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.space10,
                        vertical: Dimensions.space5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.mediumRadius)),
                    child: Column(
                      children: [
                        MyImageWidget(
                          imageUrl:
                              '${controller.userImagePath}/${controller.rider?.avatar}',
                          height: 80,
                          width: 80,
                          radius: 40,
                          isProfile: true,
                        ),
                        spaceDown(Dimensions.space10),
                        Text(controller.rider?.email ?? '',
                            style:
                                lightDefault.copyWith(color: MyColor.bodyText)),
                        Text(
                            '${controller.rider?.firstname ?? ''} ${controller.rider?.lastname ?? ''}',
                            style: semiBoldDefault.copyWith(
                                color: MyColor.primaryColor, fontSize: 24)),
                      ],
                    ),
                  ),
                  spaceDown(Dimensions.space20),
                  RatingBar.builder(
                    initialRating: double.tryParse(Get.arguments ?? "0") ?? 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    itemBuilder: (context, _) => const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber),
                    ignoreGestures: true,
                    itemSize: 50,
                    onRatingUpdate: (v) {},
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space10),
                  //   color: MyColor.transparentColor,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text("Verification".tr, style: lightDefault.copyWith(fontSize: 22, color: MyColor.bodyTextColor)),
                  //       SizedBox(height: Dimensions.space10),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Container(
                  //             padding: EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space8),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: controller.isVerified(isEmail: true) ? MyColor.colorGreen.withValues(alpha: 0.3) : MyColor.colorRed.withValues(alpha: 0.3)),
                  //             child: Row(
                  //               children: [
                  //                 Icon(Icons.verified_user_outlined, size: 20, color: controller.isVerified(isEmail: true) ? MyColor.colorGreen : MyColor.colorRed),
                  //                 SizedBox(width: Dimensions.space10),
                  //                 Text(MyStrings.email.tr, style: boldDefault.copyWith(fontSize: 13, color: MyColor.colorWhite)),
                  //               ],
                  //             ),
                  //           ),
                  //           SizedBox(width: Dimensions.space10),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space8),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: controller.isVerified(isMobile: true) ? MyColor.colorGreen.withValues(alpha: 0.3) : MyColor.colorRed.withValues(alpha: 0.3)),
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Icon(Icons.verified_user_outlined, size: 20, color: controller.isVerified(isMobile: true) ? MyColor.colorGreen : MyColor.colorRed),
                  //                 SizedBox(width: Dimensions.space10),
                  //                 Text(MyStrings.phone.tr, style: boldDefault.copyWith(fontSize: 13, color: MyColor.colorWhite)),
                  //               ],
                  //             ),
                  //           ),
                  //           SizedBox(width: Dimensions.space10),
                  //           Container(
                  //             padding: EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space8),
                  //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: controller.isVerified(isKYC: true) ? MyColor.colorGreen.withValues(alpha: 0.3) : MyColor.colorRed.withValues(alpha: 0.3)),
                  //             child: Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Icon(Icons.verified_user_outlined, size: 20, color: controller.isVerified(isKYC: true) ? MyColor.colorGreen : MyColor.colorRed),
                  //                 SizedBox(width: Dimensions.space10),
                  //                 Text(MyStrings.kyc.tr, style: boldDefault.copyWith(fontSize: 13, color: MyColor.colorWhite)),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  spaceDown(Dimensions.space20),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Review History',
                          style: lightDefault.copyWith(
                              fontSize: 22, color: MyColor.bodyTextColor))),
                  spaceDown(Dimensions.space10),
                  UserReviewList()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
