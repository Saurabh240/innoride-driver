import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_images.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/account/profile_controller.dart';
import 'package:ovoride_driver/presentation/components/column_widget/card_column.dart';
import 'package:ovoride_driver/presentation/components/divider/custom_divider.dart';
import 'package:ovoride_driver/presentation/components/image/circle_shape_image.dart';

import '../../../components/card/app_body_card.dart';

class ProfileTopSection extends StatefulWidget {
  const ProfileTopSection({super.key});

  @override
  State<ProfileTopSection> createState() => _ProfileTopSectionState();
}

class _ProfileTopSectionState extends State<ProfileTopSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => AppBodyWidgetCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.user),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.name.tr,
                    body: controller.model.data?.driver?.username ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.email),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.email.tr,
                    body: controller.model.data?.driver?.email ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.phone),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.phone.tr,
                    body: controller.model.data?.driver?.mobile ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.address),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.address.tr,
                    body: controller.model.data?.driver?.address ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.state),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.state.tr,
                    body: controller.model.data?.driver?.state ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.zipCode),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.zipCode.tr,
                    body: controller.model.data?.driver?.zip ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.city),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.city.tr,
                    body: controller.model.data?.driver?.city ?? "")
              ],
            ),
            const CustomDivider(space: Dimensions.space15),
            Row(
              children: [
                const CircleShapeImage(
                    imageColor: MyColor.primaryColor, image: MyImages.country),
                const SizedBox(width: Dimensions.space15),
                CardColumn(
                    header: MyStrings.country.tr,
                    body: controller.model.data?.driver?.countryName ?? "")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
