// import 'package:at_chat_flutter/models/message_model.dart';
// import 'package:at_chat_flutter/utils/dialog_utils.dart';
import 'package:spacesignal/app/modules/chat/utils/message_model.dart';
import 'package:at_chat_flutter/utils/colors.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/at_common_flutter.dart';
//import 'package:at_chat_flutter/widgets/contacts_initials.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:flutter/material.dart';
import 'package:spacesignal/app/modules/chat/utils/dialog_utils.dart';

class OutgoingMessageBubble extends StatefulWidget {
  final Message? message;
  final Color color;
  final Color avatarColor;
  final Function(String?) deleteCallback;
  final initialimage myImage;

  const OutgoingMessageBubble(this.deleteCallback,
      {Key? key,
        this.message,
        this.color = CustomColors.outgoingMessageColor,
        required this.myImage,
        this.avatarColor = CustomColors.defaultColor})
      : super(key: key);
  @override
  _OutgoingMessageBubbleState createState() => _OutgoingMessageBubbleState();
}

class _OutgoingMessageBubbleState extends State<OutgoingMessageBubble> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
        onLongPress: () {
          showBottomSheetDialog(context, () {
            widget.deleteCallback(widget.message?.id);
          });
        },
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                      fontSize: 15.toFont,
                      height: 1.5.toHeight,
                    )),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.delete),
            //   tooltip: 'Delete Message',
            //   onPressed: () async {
            //     widget.deleteCallback(widget.message?.id);
            //   },
            // ),

            SizedBox(
              width: 10.toWidth,
            ),
            Container(
              //margin: EdgeInsets.only(bottom: 20),
              height: 40.toFont,
              width: 40.toFont,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45.toWidth),
              ),
              child: widget.myImage,

            ),
            SizedBox(
              width: 20.toWidth,
            )
          ],
        ));
  }
}
