import 'package:flutter/material.dart';
import '../../theme/app_text_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  const AppText.heading1(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  const AppText.heading2(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  const AppText.heading3(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  const AppText.subHeading(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  const AppText.body(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  const AppText.caption(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  }) : style = null;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    
    if (runtimeType.toString().contains('heading1')) {
      textStyle = AppTextStyle.heading1;
    } else if (runtimeType.toString().contains('heading2')) {
      textStyle = AppTextStyle.heading2;
    } else if (runtimeType.toString().contains('heading3')) {
      textStyle = AppTextStyle.heading3;
    } else if (runtimeType.toString().contains('subHeading')) {
      textStyle = AppTextStyle.subHeading;
    } else if (runtimeType.toString().contains('body')) {
      textStyle = AppTextStyle.body;
    } else if (runtimeType.toString().contains('caption')) {
      textStyle = AppTextStyle.caption;
    } else {
      textStyle = style ?? AppTextStyle.body;
    }

    if (color != null) {
      textStyle = textStyle.copyWith(color: color);
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}