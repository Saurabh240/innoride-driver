import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/data/controller/vehicle_verification/vehicle_verification_controller.dart';
import 'package:ovoride_driver/data/model/global/formdata/global_keyc_formData.dart';
import 'package:ovoride_driver/data/repo/vehicle_verification/vehicle_verification_repo.dart';
import 'package:ovoride_driver/data/services/api_service.dart';
import 'package:ovoride_driver/presentation/components/checkbox/custom_check_box.dart';
import 'package:ovoride_driver/presentation/components/custom_drop_down_button_with_text_field.dart';
import 'package:ovoride_driver/presentation/components/custom_loader/custom_loader.dart';
import 'package:ovoride_driver/presentation/components/custom_radio_button.dart';
import 'package:ovoride_driver/presentation/components/image/my_network_image_widget.dart';
import 'package:ovoride_driver/presentation/screens/auth/kyc/driver/widget/widget/file_item_vehicle.dart';
import 'package:ovoride_driver/presentation/screens/vehicle_verification/widget/vahecle_alrady_veified_widget.dart';
import 'package:ovoride_driver/presentation/screens/vehicle_verification/widget/vehicle_verification_pending.dart';

import '../../../core/utils/dimensions.dart';
import '../../../core/utils/my_color.dart';
import '../../../core/utils/my_strings.dart';
import '../../../core/utils/style.dart';
import '../../../core/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/divider/custom_spacer.dart';
import '../../components/text-form-field/custom_text_field.dart';
import '../../components/text/header_text.dart';
import '../../components/text/label_text_with_instructions.dart';

class VehicleVerificationScreen extends StatefulWidget {
  const VehicleVerificationScreen({super.key});

  @override
  State<VehicleVerificationScreen> createState() =>
      _VehicleVerificationScreenState();
}

class _VehicleVerificationScreenState extends State<VehicleVerificationScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(VehicleVerificationRepo(apiClient: Get.find()));
    Get.put(VehicleVerificationController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<VehicleVerificationController>().beforeInitLoadKycData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleVerificationController>(builder: (controller) {
      return Scaffold(
        appBar: CustomAppBar(
          isShowBackBtn: true,
          bgColor: MyColor.getAppBarColor(),
          title: controller.isAlreadyVerified
              ? MyStrings.vehicleInformation.tr
              : MyStrings.vehicleVerification.tr,
        ),
        body: SingleChildScrollView(
          padding: Dimensions.previewPaddingHV,
          physics: const BouncingScrollPhysics(),
          child: controller.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(Dimensions.space15),
                  child: CustomLoader(isFullScreen: true))
              : controller.isAlreadyPending
                  ? const VehicleVerificationPendingSection()
                  : controller.isNoDataFound
                      ? const VehicleAlreadyVerifiedWidget(isPending: false)
                      : Container(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          decoration: BoxDecoration(
                              color: MyColor.getCardBgColor(),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.space12),
                              boxShadow: MyUtils.getCardShadow()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(Dimensions.space5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeaderText(
                                      text: MyStrings.vehicleVerification.tr,
                                      textStyle: boldExtraLarge.copyWith(
                                        color: MyColor.colorBlack,
                                        fontSize: Dimensions.fontLarge + 1,
                                      ),
                                    ),
                                    spaceDown(Dimensions.space3),
                                    Text(
                                      MyStrings.vehicleVerificationSubTitle.tr,
                                      style: regularDefault.copyWith(
                                        color: MyColor.bodyText,
                                        fontSize: Dimensions.fontMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              spaceDown(Dimensions.space15),
                              Padding(
                                padding:
                                    const EdgeInsets.all(Dimensions.space5),
                                child: HeaderText(
                                    text: MyStrings.selectService,
                                    textStyle: boldLarge.copyWith(
                                        color: MyColor.getRideTitleColor(),
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimensions.fontOverLarge)),
                              ),
                              spaceDown(Dimensions.space10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                    controller.services.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: () => {
                                          controller.selectService(
                                              controller.services[index])
                                        },
                                        child: IntrinsicHeight(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            width: Dimensions.space50 * 1.8,
                                            decoration: BoxDecoration(
                                              color: MyColor.colorWhite,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.mediumRadius),
                                              border: controller
                                                          .services[index].id ==
                                                      controller
                                                          .selectedService.id
                                                  ? Border.all(
                                                      color:
                                                          MyColor.primaryColor,
                                                      width: 1.5)
                                                  : Border.all(
                                                      color: MyColor.colorGrey2,
                                                      width: 1.2),
                                            ),
                                            child: FittedBox(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  MyImageWidget(
                                                      imageUrl:
                                                          "${controller.serviceImagePath}/${controller.services[index].image ?? ''}",
                                                      height: 60,
                                                      width: 60,
                                                      radius: 10),
                                                  spaceDown(Dimensions.space10),
                                                  FittedBox(
                                                    child: Text(
                                                      controller.services[index]
                                                              .name ??
                                                          '',
                                                      style: regularDefault
                                                          .copyWith(),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              spaceDown(Dimensions.space15),
                              Padding(
                                padding:
                                    const EdgeInsets.all(Dimensions.space5),
                                child: HeaderText(
                                  text: MyStrings.selectBrand,
                                  textStyle: boldLarge.copyWith(
                                      color: MyColor.getRideTitleColor(),
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimensions.fontOverLarge),
                                ),
                              ),
                              spaceDown(Dimensions.space20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                    controller.brands.length,
                                    (index) => GestureDetector(
                                      onTap: () => {
                                        controller.selectBrand(
                                            controller.brands[index])
                                      },
                                      child: IntrinsicHeight(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 8),
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          width: Dimensions.space50 * 1.8,
                                          decoration: BoxDecoration(
                                            color: MyColor.colorWhite,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.defaultRadius),
                                            border: controller
                                                        .brands[index].id ==
                                                    controller.selectedBrand.id
                                                ? Border.all(
                                                    color: MyColor.primaryColor,
                                                    width: 1.5)
                                                : Border.all(
                                                    color: MyColor.colorGrey2,
                                                    width: 1.2),
                                          ),
                                          child: FittedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MyImageWidget(
                                                  imageUrl:
                                                      "${controller.brandImagePath}/${controller.brands[index].image ?? ''}",
                                                  height: 40,
                                                  width: 60,
                                                  radius: 1,
                                                  boxFit: BoxFit.fill,
                                                ),
                                                spaceDown(Dimensions.space10),
                                                FittedBox(
                                                  child: Text(
                                                      controller.brands[index]
                                                              .name ??
                                                          '',
                                                      style: regularDefault
                                                          .copyWith()),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              spaceDown(Dimensions.space20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  controller.formList.length,
                                              itemBuilder: (ctx, index) {
                                                GlobalFormModel? model =
                                                    controller.formList[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      model.type == 'text' ||
                                                              model.type ==
                                                                  'number' ||
                                                              model.type ==
                                                                  'email' ||
                                                              model.type ==
                                                                  'url'
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomTextField(
                                                                  hintText: (model
                                                                              .name ??
                                                                          '')
                                                                      .toLowerCase()
                                                                      .capitalizeFirst,
                                                                  isShowInstructionWidget:
                                                                      true,
                                                                  instructions:
                                                                      model
                                                                          .instruction,
                                                                  needOutlineBorder:
                                                                      true,
                                                                  labelText:
                                                                      model.name ??
                                                                          '',
                                                                  isRequired:
                                                                      model.isRequired ==
                                                                              'optional'
                                                                          ? false
                                                                          : true,
                                                                  textInputType: model
                                                                              .type ==
                                                                          'number'
                                                                      ? TextInputType
                                                                          .number
                                                                      : model.type ==
                                                                              'email'
                                                                          ? TextInputType
                                                                              .emailAddress
                                                                          : model.type == 'url'
                                                                              ? TextInputType.url
                                                                              : TextInputType.text,
                                                                  onChanged:
                                                                      (value) {
                                                                    controller
                                                                        .changeSelectedValue(
                                                                            value,
                                                                            index);
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (model.isRequired !=
                                                                            'optional' &&
                                                                        value
                                                                            .toString()
                                                                            .isEmpty) {
                                                                      return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                                const SizedBox(
                                                                    height: Dimensions
                                                                        .space10),
                                                              ],
                                                            )
                                                          : model.type ==
                                                                  'textarea'
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CustomTextField(
                                                                      instructions:
                                                                          model
                                                                              .instruction,
                                                                      needOutlineBorder:
                                                                          true,
                                                                      isShowInstructionWidget:
                                                                          true,
                                                                      labelText:
                                                                          model.name ??
                                                                              '',
                                                                      isRequired: model.isRequired ==
                                                                              'optional'
                                                                          ? false
                                                                          : true,
                                                                      hintText: (model.name ??
                                                                              '')
                                                                          .capitalizeFirst,
                                                                      textInputType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          5,
                                                                      onChanged:
                                                                          (value) {
                                                                        controller.changeSelectedValue(
                                                                            value,
                                                                            index);
                                                                      },
                                                                      validator:
                                                                          (value) {
                                                                        if (model.isRequired !=
                                                                                'optional' &&
                                                                            value.toString().isEmpty) {
                                                                          return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            Dimensions.space10),
                                                                  ],
                                                                )
                                                              : model.type ==
                                                                      'select'
                                                                  ? Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        LabelTextInstruction(
                                                                          text: model.name ??
                                                                              '',
                                                                          isRequired: model.isRequired == 'optional'
                                                                              ? false
                                                                              : true,
                                                                          instructions:
                                                                              model.instruction,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              Dimensions.textToTextSpace,
                                                                        ),
                                                                        CustomDropDownWithTextField(
                                                                            list: model.options ??
                                                                                [],
                                                                            onChanged:
                                                                                (value) {
                                                                              controller.changeSelectedValue(value, index);
                                                                            },
                                                                            selectedValue:
                                                                                model.selectedValue),
                                                                        const SizedBox(
                                                                            height:
                                                                                Dimensions.space10)
                                                                      ],
                                                                    )
                                                                  : model.type ==
                                                                          'radio'
                                                                      ? Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            LabelTextInstruction(
                                                                              text: model.name ?? '',
                                                                              isRequired: model.isRequired == 'optional' ? false : true,
                                                                              instructions: model.instruction,
                                                                            ),
                                                                            CustomRadioButton(
                                                                              title: model.name,
                                                                              selectedIndex: controller.formList[index].options?.indexOf(model.selectedValue ?? '') ?? 0,
                                                                              list: model.options ?? [],
                                                                              onChanged: (selectedIndex) {
                                                                                controller.changeSelectedRadioBtnValue(index, selectedIndex);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : model.type ==
                                                                              'checkbox'
                                                                          ? Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                LabelTextInstruction(
                                                                                  text: model.name ?? '',
                                                                                  isRequired: model.isRequired == 'optional' ? false : true,
                                                                                  instructions: model.instruction,
                                                                                ),
                                                                                CustomCheckBox(
                                                                                  selectedValue: controller.formList[index].cbSelected,
                                                                                  list: model.options ?? [],
                                                                                  onChanged: (value) {
                                                                                    controller.changeSelectedCheckBoxValue(index, value);
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : model.type == 'file'
                                                                              ? Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    LabelTextInstruction(
                                                                                      text: model.name ?? '',
                                                                                      isRequired: model.isRequired == 'optional' ? false : true,
                                                                                      instructions: model.instruction,
                                                                                    ),
                                                                                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace), child: FileItemForVehicle(index: index))
                                                                                  ],
                                                                                )
                                                                              : model.type == 'datetime'
                                                                                  ? Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                                          child: CustomTextField(
                                                                                              isShowInstructionWidget: true,
                                                                                              instructions: model.instruction,
                                                                                              isRequired: model.isRequired == 'optional' ? false : true,
                                                                                              hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                                              needOutlineBorder: true,
                                                                                              labelText: model.name ?? '',
                                                                                              controller: controller.formList[index].textEditingController,
                                                                                              textInputType: TextInputType.datetime,
                                                                                              readOnly: true,
                                                                                              validator: (value) {
                                                                                                if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                                  return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                                                } else {
                                                                                                  return null;
                                                                                                }
                                                                                              },
                                                                                              onTap: () {
                                                                                                controller.changeSelectedDateTimeValue(index, context);
                                                                                              },
                                                                                              onChanged: (value) {
                                                                                                controller.changeSelectedValue(value, index);
                                                                                              }),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : model.type == 'date'
                                                                                      ? Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                                              child: CustomTextField(
                                                                                                  isShowInstructionWidget: true,
                                                                                                  instructions: model.instruction,
                                                                                                  isRequired: model.isRequired == 'optional' ? false : true,
                                                                                                  hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                                                  needOutlineBorder: true,
                                                                                                  labelText: model.name ?? '',
                                                                                                  controller: controller.formList[index].textEditingController,
                                                                                                  textInputType: TextInputType.datetime,
                                                                                                  readOnly: true,
                                                                                                  validator: (value) {
                                                                                                    if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                                      return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                                                    } else {
                                                                                                      return null;
                                                                                                    }
                                                                                                  },
                                                                                                  onTap: () {
                                                                                                    controller.changeSelectedDateOnlyValue(index, context);
                                                                                                  },
                                                                                                  onChanged: (value) {
                                                                                                    controller.changeSelectedValue(value, index);
                                                                                                  }),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : model.type == 'time'
                                                                                          ? Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.textToTextSpace),
                                                                                                  child: CustomTextField(
                                                                                                      isShowInstructionWidget: true,
                                                                                                      instructions: model.instruction,
                                                                                                      isRequired: model.isRequired == 'optional' ? false : true,
                                                                                                      hintText: (model.name ?? '').toString().capitalizeFirst,
                                                                                                      needOutlineBorder: true,
                                                                                                      labelText: model.name ?? '',
                                                                                                      controller: controller.formList[index].textEditingController,
                                                                                                      textInputType: TextInputType.datetime,
                                                                                                      readOnly: true,
                                                                                                      validator: (value) {
                                                                                                        if (model.isRequired != 'optional' && value.toString().isEmpty) {
                                                                                                          return '${model.name.toString().capitalizeFirst} ${MyStrings.isRequired}';
                                                                                                        } else {
                                                                                                          return null;
                                                                                                        }
                                                                                                      },
                                                                                                      onTap: () {
                                                                                                        controller.changeSelectedTimeOnlyValue(index, context);
                                                                                                      },
                                                                                                      onChanged: (value) {
                                                                                                        controller.changeSelectedValue(value, index);
                                                                                                      }),
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          : const SizedBox(),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .space10),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(Dimensions.space5),
                                child: HeaderText(
                                    text: MyStrings.selectRideRules.tr,
                                    textStyle: boldMediumLarge.copyWith(
                                        color: MyColor.getRideSubTitleColor())),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.riderRules.length,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    activeColor: MyColor.getPrimaryColor(),
                                    title: Text(
                                      controller.riderRules[index].name ?? '',
                                      style: regularLarge.copyWith(
                                          color:
                                              MyColor.getRideSubTitleColor()),
                                    ),
                                    value: controller.selectedRiderRules
                                        .contains(controller.riderRules[index]),
                                    onChanged: (value) {
                                      controller.selectRideRule(
                                          controller.riderRules[index]);
                                    },
                                  );
                                },
                              ),
                              spaceDown(Dimensions.space15),
                              RoundedButton(
                                text: MyStrings.submit,
                                isLoading: controller.submitLoading,
                                press: () {
                                  if (formKey.currentState!.validate()) {
                                    controller.submitKycData();
                                  }
                                },
                                textColor: MyColor.colorWhite,
                                isOutlined: false,
                              ),
                              spaceDown(Dimensions.space15),
                            ],
                          ),
                        ),
        ),
      );
    });
  }
}
