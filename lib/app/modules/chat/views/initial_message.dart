// import 'package:spacesignal/utils/message_model.dart';
// import 'package:at_chat_flutter/models/message_model.dart';
import 'package:at_chat_flutter/utils/colors.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/at_common_flutter.dart';
//import 'package:at_chat_flutter/widgets/contacts_initials.dart';
// import 'package:spacesignal/utils/initial_image.dart';
import 'package:flutter/material.dart';
import 'package:spacesignal/app/modules/chat/utils/message_model.dart';

class InitialMessageBubble extends StatefulWidget {
  final Message? message;
  // final Color color;
  // final Color avatarColor;

  const InitialMessageBubble(
      {Key? key,
        this.message,
        // this.color = Colors.yellow,
        // this.avatarColor = CustomColors.defaultColor
      })
      : super(key: key);
  @override
  _InitialMessageBubbleState createState() => _InitialMessageBubbleState();
}

class _InitialMessageBubbleState extends State<InitialMessageBubble> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var color = Colors.purple[100];
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.toWidth,
        ),
        // Container(
        //   // margin: EdgeInsets.only(bottom: 20),
        //   height: 40.toFont,
        //   width: 40.toFont,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(45.toWidth),
        //   ),
        //   child: initialimage(
        //     atsign: widget.message?.sender ?? '@',
        //     backgroundColor: widget.avatarColor,
        //   ),
        // ),
        // SizedBox(
        //   width: 10.toWidth,
        // ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.toHeight,horizontal: 13.toWidth),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.toWidth),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 210.toWidth),
            child: Text(
                widget.message?.message ?? ' ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.5.toHeight,
                  fontSize: 15.toFont,
                )
              //maxLines: 3,
            ),
          ),
        ),
      ],
    );
  }
}
