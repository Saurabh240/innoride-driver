import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ovoride_driver/core/helper/string_format_helper.dart';
import 'package:ovoride_driver/core/utils/my_icons.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/controller/map/ride_map_controller.dart';
import 'package:ovoride_driver/data/controller/pusher/pusher_ride_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_details/ride_details_controller.dart';
import 'package:ovoride_driver/data/controller/ride/ride_meassage/ride_meassage_controller.dart';
import 'package:ovoride_driver/data/model/global/app/ride_meassage_model.dart';
import 'package:ovoride_driver/data/repo/meassage/meassage_repo.dart';
import 'package:ovoride_driver/data/repo/ride/ride_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/components/image/my_local_image_widget.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_animation.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/image/my_network_image_widget.dart';
import '../../packages/flutter_chat_bubble/chat_bubble.dart';

class RideMessageScreen extends StatefulWidget {
  String rideID;
  RideMessageScreen({super.key, required this.rideID});

  @override
  State<RideMessageScreen> createState() => _RideMessageScreenState();
}

class _RideMessageScreenState extends State<RideMessageScreen> {
  Timer? timer;

  @override
  void initState() {
    widget.rideID = Get.arguments;
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(MessageRepo(apiClient: Get.find()));
    Get.put(RideRepo(apiClient: Get.find()));
    Get.put(RideMapController());
    Get.put(RideDetailsController(repo: Get.find(), mapController: Get.find()));
    final controller = Get.put(RideMessageController(repo: Get.find()));
    Get.put(PusherRideController(
        apiClient: Get.find(),
        controller: Get.find(),
        detailsController: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      controller.initialData(Get.arguments);
      Get.find<PusherRideController>().subscribePusher(rideId: Get.arguments);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    Get.find<PusherRideController>().clearData();
  }

  @override
  Widget build(BuildContext context) {
    getSenderView(CustomClipper clipper, BuildContext context, RideMessage item,
        imagePath) {
      return AnimatedContainer(
        duration: const Duration(microseconds: 500),
        curve: Curves.easeIn,
        child: ChatBubble(
          clipper: clipper,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 5),
          backGroundColor: MyColor.primaryColor,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                item.image != "null" && item.image!.isNotEmpty
                    ? InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          Get.toNamed(RouteHelper.previewImageScreen,
                              arguments: "$imagePath/${item.image}");
                        },
                        child: MyImageWidget(
                          width: 100,
                          height: 80,
                          imageUrl: "$imagePath/${item.image}",
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: Dimensions.space2),
                Text('${item.message}',
                    style: const TextStyle(color: MyColor.colorWhite)),
              ],
            ),
          ),
        ),
      );
    }

    getReceiverView(CustomClipper clipper, BuildContext context,
        RideMessage item, String imagePath) {
      printX('imagePath ${item.image}');
      return AnimatedContainer(
        duration: const Duration(microseconds: 500),
        curve: Curves.easeIn,
        child: ChatBubble(
          clipper: clipper,
          backGroundColor: Colors.black54,
          margin: const EdgeInsets.only(top: 20),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item.image != "null" && item.image!.isNotEmpty
                    ? InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          Get.toNamed(RouteHelper.previewImageScreen,
                              arguments: "$imagePath/${item.image}");
                        },
                        child: MyImageWidget(
                          imageUrl: "$imagePath/${item.image}",
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: Dimensions.space2),
                Text('${item.message}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    return GetBuilder<RideMessageController>(
      builder: (controller) {
        return GetBuilder<PusherRideController>(builder: (pushController) {
          return Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColor.screenBgColor,
            appBar: CustomAppBar(
              title: MyStrings.inbox.tr,
              backBtnPress: () {
                Get.back();
              },
              actionsWidget: [
                IconButton(
                  onPressed: () {
                    controller.getRideMessage(controller.rideId, p: 1);
                  },
                  icon: const Icon(
                    Icons.refresh_outlined,
                    color: MyColor.colorWhite,
                  ),
                )
              ],
            ),
            body: pushController.isPusherLoading
                ? const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomLoader(),
                  )
                : controller.isLoading
                    ? const CustomLoader()
                    : controller.meassage.isEmpty
                        ? SizedBox(
                            height: context.height,
                            child: LottieBuilder.asset(
                              MyAnimation.emptyChat,
                              repeat: false,
                            ),
                          )
                        : ListView.builder(
                            controller: controller.scrollController,
                            padding: const EdgeInsetsDirectional.only(
                                start: Dimensions.space20,
                                end: Dimensions.space20,
                                bottom: Dimensions.space50 * 2),
                            itemCount: controller.meassage.length,
                            reverse: true,
                            itemBuilder: (c, index) {
                              var item = controller.meassage[index];
                              if (item.driverId == "0") {
                                return getReceiverView(
                                    ChatBubbleClipper3(
                                        type: BubbleType.receiverBubble),
                                    context,
                                    item,
                                    controller.imagePath);
                              } else {
                                return getSenderView(
                                    ChatBubbleClipper3(
                                        type: BubbleType.sendBubble),
                                    context,
                                    item,
                                    controller.imagePath);
                              }
                            }),
            bottomNavigationBar: controller.isLoading
                ? SizedBox.shrink()
                : AnimatedPadding(
                    padding: MediaQuery.of(context).viewInsets,
                    duration: const Duration(milliseconds: 50),
                    child: Container(
                      color: MyColor.transparentColor,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: Dimensions.space20,
                            right: Dimensions.space20,
                            bottom: Dimensions.space10,
                            top: Dimensions.space10),
                        decoration: BoxDecoration(
                          color: MyColor.colorWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: Dimensions.space50 + 6,
                        child: Row(
                          children: [
                            Expanded(
                              child: controller.imageFile == null
                                  ? GestureDetector(
                                      onTap: () => controller.pickFile(),
                                      child: Icon(Icons.image,
                                          color: MyColor.primaryColor))
                                  : Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                              controller.imageFile!,
                                              height: 40,
                                              width: 35))),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsetsDirectional.only(start: 7),
                                decoration: BoxDecoration(
                                    color: MyColor.transparentColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                  controller: controller.meassageController,
                                  cursorColor: MyColor.getPrimaryColor(),
                                  style: regularSmall.copyWith(
                                      color: MyColor.getTextColor()),
                                  readOnly: false,
                                  maxLines: null,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                      hintText: MyStrings.writeYourMessage.tr,
                                      hintStyle: mediumDefault.copyWith(
                                          color: MyColor.bodyTextColor
                                              .withValues(alpha: 0.7)),
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none),
                                  onFieldSubmitted: (value) {
                                    if (controller.meassageController.text
                                            .isNotEmpty &&
                                        controller.isSubmitLoading == false) {
                                      controller.sendMessage();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  end: Dimensions.space15),
                              child: InkWell(
                                onTap: () {
                                  if (controller
                                          .meassageController.text.isNotEmpty &&
                                      controller.isSubmitLoading == false) {
                                    controller.sendMessage();
                                  }
                                },
                                child: controller.isSubmitLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            color: MyColor.primaryColor),
                                      )
                                    : const MyLocalImageWidget(
                                        imagePath: MyIcons.sendArrow,
                                        width: Dimensions.space35,
                                        height: Dimensions.space35),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
      },
    );
  }
}
