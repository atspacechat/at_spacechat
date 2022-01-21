// import 'package:at_chat_flutter/models/message_model.dart';
import 'package:at_contact/at_contact.dart';
import 'package:spacesignal/app/modules/chat/utils/message_model.dart';
import 'package:at_chat_flutter/utils/colors.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/at_common_flutter.dart';
//import 'package:at_chat_flutter/widgets/contacts_initials.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:flutter/material.dart';

class IncomingMessageBubble extends StatefulWidget {
  final Message? message;
  final Color color;
  final Color avatarColor;
  final AtContact? contact;
  final initialimage? contactImage;

  const IncomingMessageBubble(
      {Key? key,
        this.message,
        this.contactImage,
        this.color = CustomColors.incomingMessageColor,
        this.avatarColor = CustomColors.defaultColor,
        this.contact
      })
      : super(key: key);
  @override
  _IncomingMessageBubbleState createState() => _IncomingMessageBubbleState();
}

class _IncomingMessageBubbleState extends State<IncomingMessageBubble> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.toWidth,
        ),
        Container(
          // margin: EdgeInsets.only(bottom: 20),
          height: 40.toFont,
          width: 40.toFont,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45.toWidth),
          ),
          child: widget.contactImage,
        ),
        SizedBox(
          width: 10.toWidth,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.toHeight,horizontal: 13.toWidth),
          decoration: BoxDecoration(
            color: widget.color,
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
