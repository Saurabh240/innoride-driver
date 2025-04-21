import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/core/utils/dimensions.dart';
import 'package:ovoride_driver/core/utils/my_color.dart';
import 'package:ovoride_driver/core/utils/style.dart';

class LocationPickTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onTap;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  final bool isRequired;
  final VoidCallback? onSubmit;
  final List<TextInputFormatter>? inputFormatters;
  final double? radius;
  const LocationPickTextField({
    super.key,
    this.labelText,
    this.readOnly = false,
    this.fillColor = MyColor.transparentColor,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onTap,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
    this.onSubmit,
    this.radius = Dimensions.defaultRadius,
    this.inputFormatters,
  });

  @override
  State<LocationPickTextField> createState() => _LocationPickTextFieldState();
}

class _LocationPickTextFieldState extends State<LocationPickTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        style: regularDefault.copyWith(color: MyColor.getTextColor()),
        //textAlign: TextAlign.left,
        cursorColor: MyColor.getTextColor(),
        controller: widget.controller,
        autofocus: false,
        textInputAction: widget.inputAction,
        enabled: widget.isEnable,
        focusNode: widget.focusNode,
        validator: widget.validator,
        keyboardType: widget.textInputType,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.only(
              top: 5, start: 15, end: 15, bottom: 5),

          // labelText: widget.labelText?.tr ?? '',
          // labelStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor()),
          fillColor: widget.fillColor,
          filled: true,
          hintText: widget.hintText?.tr ?? '',
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: MyColor.getTextFieldDisableBorder()),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: MyColor.getTextFieldEnableBorder(),
            ),
            borderRadius: BorderRadius.circular(widget.radius!),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 0.5, color: MyColor.getTextFieldDisableBorder()),
              borderRadius: BorderRadius.circular(widget.radius!)),
        ),
        onFieldSubmitted: (text) => widget.nextFocus != null
            ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : null,
        onChanged: (text) => widget.onChanged!(text),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        });
  }
}
