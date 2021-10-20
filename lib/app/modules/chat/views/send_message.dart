import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/services/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SendMessage extends StatefulWidget {
  final Function? onSend;
  final ValueChanged<String>? messageCallback;
  final Color? sendButtonColor;
  final String? hintText;
  const SendMessage(
      {Key? key,
        this.onSend,
        this.messageCallback,
        this.sendButtonColor,
        this.hintText})
      : super(key: key);
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController? _sendController;

  @override
  void initState() {
    _sendController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _sendController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: 50.toHeight,
      margin: EdgeInsets.only(left:10.toHeight,right:10.toHeight,top:10.toHeight,bottom:20.toHeight),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.toHeight),
          color: Colors.grey[200]),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.toHeight),
                child: TextField(
                  controller: _sendController,
                  onChanged: (s) {
                    widget.messageCallback!(s);
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: widget.hintText ?? 'Type a message to send',
                      border: InputBorder.none),
                ),
              )),

          IconButton(
              icon: Icon(
                //Icons.arrow_forward,
                MdiIcons.sendCircle,
                //color: widget.sendButtonColor ?? Colors.orange,
                color: Color(0xFF584797).withOpacity(0.9),
              ),
              iconSize: 50.toHeight,
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.0,
              ),
              onPressed: () {
                widget.messageCallback!(_sendController!.text);
                widget.onSend!();
                _sendController!.clear();
              })
        ],
      ),
    );
  }
}