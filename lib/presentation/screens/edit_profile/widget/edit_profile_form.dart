import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/my_strings.dart';
import 'package:ovoride_driver/data/controller/account/profile_controller.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';
import 'package:ovoride_driver/presentation/components/text-form-field/custom_text_field.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.space15, horizontal: Dimensions.space15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: MyColor.colorWhite, borderRadius: BorderRadius.circular(10)),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: Dimensions.space20),
              CustomTextField(
                  animatedLabel: false,
                  isRequired: true,
                  needOutlineBorder: true,
                  labelText: MyStrings.firstName.tr,
                  onChanged: (value) {},
                  focusNode: controller.firstNameFocusNode,
                  controller: controller.firstNameController),
              const SizedBox(height: Dimensions.space15),
              CustomTextField(
                  animatedLabel: false,
                  isRequired: true,
                  needOutlineBorder: true,
                  labelText: MyStrings.lastName.tr,
                  onChanged: (value) {},
                  focusNode: controller.lastNameFocusNode,
                  controller: controller.lastNameController),
              const SizedBox(height: Dimensions.space15),
              CustomTextField(
                  animatedLabel: false,
                  needOutlineBorder: true,
                  labelText: MyStrings.address.tr,
                  onChanged: (value) {},
                  focusNode: controller.addressFocusNode,
                  controller: controller.addressController),
              const SizedBox(height: Dimensions.space15),
              CustomTextField(
                  animatedLabel: false,
                  needOutlineBorder: true,
                  labelText: MyStrings.state.tr,
                  onChanged: (value) {},
                  focusNode: controller.stateFocusNode,
                  controller: controller.stateController),
              const SizedBox(height: Dimensions.space15),
              CustomTextField(
                  animatedLabel: false,
                  needOutlineBorder: true,
                  labelText: MyStrings.zipCode.tr,
                  onChanged: (value) {},
                  focusNode: controller.zipCodeFocusNode,
                  controller: controller.zipCodeController),
              const SizedBox(height: Dimensions.space15),
              CustomTextField(
                  animatedLabel: false,
                  needOutlineBorder: true,
                  labelText: MyStrings.city.tr,
                  onChanged: (value) {},
                  focusNode: controller.cityFocusNode,
                  controller: controller.cityController),
              const SizedBox(height: Dimensions.space30),
              RoundedButton(
                isLoading: controller.isSubmitLoading,
                press: () {
                  controller.updateProfile();
                },
                text: MyStrings.updateProfile.tr,
              )
            ],
          ),
        ),
      ),
    );
  }
}
