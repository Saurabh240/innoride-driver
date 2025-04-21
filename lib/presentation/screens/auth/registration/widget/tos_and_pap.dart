import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ovoride_driver/core/utils/style.dart';

import '../../../../../core/utils/my_color.dart';

class ClickableTermsText extends StatelessWidget {
  const ClickableTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By signing up, you agree to the ',
            style: regularDefault.copyWith(color: MyColor.bodyText),
          ),
          TextSpan(
            text: 'Terms of Service',
            style: regularDefault.copyWith(
              color: MyColor.primaryColor,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: ' and ',
            style: regularDefault.copyWith(color: MyColor.bodyText),
          ),
          TextSpan(
            text: 'Privacy Policy.',
            style: regularDefault.copyWith(
              color: MyColor.primaryColor,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}
