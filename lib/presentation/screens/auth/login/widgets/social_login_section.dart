import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/style.dart';

import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_icons.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../data/controller/auth/social_login_controller.dart';
import '../../../../../data/repo/auth/social_login_repo.dart';
import '../../../../components/buttons/custom_outlined_button.dart';

class SocialLoginSection extends StatefulWidget {
  const SocialLoginSection({super.key});

  @override
  State<SocialLoginSection> createState() => _SocialLoginSectionState();
}

class _SocialLoginSectionState extends State<SocialLoginSection> {
  @override
  void initState() {
    Get.put(SocialLoginRepo(apiClient: Get.find()));
    Get.put(SocialLoginController(repo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLoginController>(builder: (controller) {
      return Visibility(
        visible: controller.repo.apiClient.isGoogleLoginEnable() == true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Center(
              child: Text(MyStrings.or.tr,
                  style: regularLarge.copyWith(color: MyColor.getTextColor())),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            CustomOutlinedBtn(
              btnText: MyStrings.google.tr,
              onTap: () {
                controller.signInWithGoogle();
              },
              isLoading: controller.isGoogleSignInLoading,
              textColor: MyColor.primaryTextColor,
              radius: 24,
              height: 55,
              icon: SvgPicture.asset(
                MyIcons.google,
                height: 22,
                width: 22,
              ),
            ),
          ],
        ),
      );
    });
  }
}
