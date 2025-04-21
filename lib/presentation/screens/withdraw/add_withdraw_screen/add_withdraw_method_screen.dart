import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/route/route.dart';
import 'package:ovoride_driver/core/utils/style.dart';
import 'package:ovoride_driver/data/model/withdraw/withdraw_method_response_model.dart';
import 'package:ovoride_driver/presentation/components/buttons/rounded_button.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../data/controller/withdraw/add_new_withdraw_controller.dart';
import '../../../../data/repo/withdraw/withdraw_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/custom_loader/custom_loader.dart';
import '../../../components/text-form-field/custom_amount_text_field.dart';
import '../../../components/text-form-field/custom_drop_down_button_with_text_field2.dart';
import 'info_widget.dart';

class AddWithdrawMethod extends StatefulWidget {
  const AddWithdrawMethod({super.key});

  @override
  State<AddWithdrawMethod> createState() => _AddWithdrawMethodState();
}

class _AddWithdrawMethodState extends State<AddWithdrawMethod> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(WithdrawRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewWithdrawController(
      repo: Get.find(),
    ));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDepositMethod();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewWithdrawController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.addWithdraw.tr,
          actionsWidget: [
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.withdrawScreen);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 7, right: 10, bottom: 7, top: 7),
                padding: const EdgeInsets.all(Dimensions.space7),
                decoration: const BoxDecoration(
                    color: MyColor.colorWhite, shape: BoxShape.circle),
                child: const Icon(Icons.history,
                    color: MyColor.primaryColor, size: 15),
              ),
            ),
          ],
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: Dimensions.screenPaddingHV1,
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgColor(),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownTextField2(
                        labelText: MyStrings.paymentMethod.tr,
                        selectedValue: controller.withdrawMethod,
                        onChanged: (value) {
                          controller.setWithdrawMethod(value);
                        },
                        items: controller.withdrawMethodList
                            .map((WithdrawMethod method) {
                          return DropdownMenuItem<WithdrawMethod>(
                            value: method,
                            child: Text((method.name ?? '').tr,
                                style: regularDefault.copyWith(
                                    color: MyColor.getTextColor())),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: Dimensions.space15),
                      CustomAmountTextField(
                        labelText: MyStrings.amount.tr,
                        hintText: MyStrings.enterAmount.tr,
                        inputAction: TextInputAction.done,
                        currency: controller.currency,
                        controller: controller.amountController,
                        onChanged: (value) {
                          if (value.toString().isEmpty) {
                            controller.changeInfoWidgetValue(0);
                          } else {
                            double amount =
                                double.tryParse(value.toString()) ?? 0;
                            controller.changeInfoWidgetValue(amount);
                          }
                          return;
                        },
                      ),
                      Visibility(
                          visible: controller.authorizationList.length > 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: Dimensions.space15),
                              CustomDropDownTextField2(
                                labelText: MyStrings.authorizationMethod.tr,
                                selectedValue:
                                    controller.selectedAuthorizationMode,
                                onChanged: (value) {
                                  controller.changeAuthorizationMode(value);
                                },
                                items: controller.authorizationList
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text((value.toString()).tr,
                                        style: regularDefault.copyWith(
                                            color: MyColor.getTextColor())),
                                  );
                                }).toList(),
                              ),
                            ],
                          )),
                      controller.mainAmount > 0
                          ? const InfoWidget()
                          : const SizedBox(),
                      const SizedBox(
                        height: Dimensions.space30,
                      ),
                      RoundedButton(
                        isLoading: controller.submitLoading,
                        text: MyStrings.submit.tr,
                        press: () {
                          controller.submitWithdrawRequest();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
