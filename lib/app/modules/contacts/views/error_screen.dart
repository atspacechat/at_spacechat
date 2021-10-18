// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:spacesignal/utils/colors.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/at_common_flutter.dart';

class ErrorScreen extends StatelessWidget {
  final Function? onPressed;
  final String msg;
  ErrorScreen(
      {this.onPressed, this.msg = 'Something went wrong, please retry.'});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(msg,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          onPressed != null
              ? CustomButton(
            buttonText: 'Retry',
            width: 120.toWidth,
            height: 40.toHeight,
            onPressed: () async {
              if (onPressed != null) {
                onPressed!();
              }
            },
            buttonColor: Theme.of(context).brightness == Brightness.light
                ? ColorConstants.fontPrimary
                : ColorConstants.scaffoldColor,
            fontColor: Theme.of(context).brightness == Brightness.light
                ? ColorConstants.scaffoldColor
                : ColorConstants.fontPrimary,
          )
              : SizedBox()
        ],
      ),
    );
  }
}