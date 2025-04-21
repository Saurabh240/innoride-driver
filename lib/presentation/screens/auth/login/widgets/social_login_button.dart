import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/style.dart';

class SocialLoginButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;
  const SocialLoginButton(
      {super.key, required this.title, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: MyColor.getTextFieldDisableBorder()),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space7, vertical: Dimensions.space12),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(end: Dimensions.space10),
                  child: SvgPicture.asset(
                    image,
                    height: Dimensions.space20,
                    width: Dimensions.space50,
                  ),
                ),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: regularLarge.copyWith(fontSize: Dimensions.fontLarge),
                )
              ]),
        ),
      ),
    );
  }
}
