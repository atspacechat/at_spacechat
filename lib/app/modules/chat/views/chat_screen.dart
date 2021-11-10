// import 'package:spacesignal/utils/message_model.dart';
// import 'package:at_chat_flutter/models/message_model.dart';
import 'package:at_chat_flutter/utils/colors.dart';
import 'package:spacesignal/app/modules/chat/utils/message_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spacesignal/app/modules/contacts/views/contacts_screen.dart';
import 'package:spacesignal/app/modules/chat/views/outgoing_message.dart';
import 'package:spacesignal/app/modules/chat/views/incoming_message.dart';
import 'package:spacesignal/app/modules/chat/views/send_message.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:spacesignal/app/modules/chat/controllers/chat_service.dart';

import 'initial_message.dart';



class ChatScreen extends StatefulWidget {
  /// [height] specifies the height of bottom sheet/screen,
  final double? height;

  /// [isScreen] toggles the screen behaviour to adapt for screen or bottom sheet,
  final bool isScreen;

  /// [outgoingMessageColor] defines the color of outgoing message color,
  final Color outgoingMessageColor;

  /// [incomingMessageColor] defines the color of incoming message color.
  final Color incomingMessageColor;

  /// [senderAvatarColor] defines the color of sender's avatar
  final Color senderAvatarColor;

  /// [receiverAvatarColor] defines the color of receiver's avatar
  final Color receiverAvatarColor;

  /// [title] specifies the title text to be displayed.
  final String title;

  /// [hintText] specifies the hint text to be displayed in the input box.
  final String? hintText;

  const ChatScreen(
      {Key? key,
        this.height,
        this.isScreen = false,
        this.outgoingMessageColor = CustomColors.outgoingMessageColor,
        this.incomingMessageColor = CustomColors.incomingMessageColor,
        this.senderAvatarColor = CustomColors.defaultColor,
        this.receiverAvatarColor = CustomColors.defaultColor,
        this.title = 'Messages',
        this.hintText})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Widget> messageList = [];
  String? message;
  ScrollController? _scrollController;
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _chatService = ChatService();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _chatService.getChatHistory();
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.toHeight),
        topRight: Radius.circular(30.toHeight),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 20.toHeight),
        height: widget.height ?? SizeConfig().screenHeight * 0.8,
        margin: widget.isScreen
            ? const EdgeInsets.all(0.0)
            : const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.toHeight),
            topRight: Radius.circular(30.toHeight),
          ),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black87
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          children: [
            (widget.isScreen)
                ? Container()
                : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,),
            Expanded(
                child: StreamBuilder<List<Message>>(
                    stream: _chatService.chatStream,
                    initialData: _chatService.chatHistory,
                    builder: (context, snapshot) {
                      return (snapshot.connectionState ==
                          ConnectionState.waiting)
                          ? Center(
                            child: CircularProgressIndicator(),
                      )
                          : (snapshot.data == null || snapshot.data!.isEmpty)
                          ? Center(
                             child: Text('No chat history found'),
                      )
                          : ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: 10.0),
                              child: snapshot.data![index].type ==
                                  MessageType.INCOMING
                                  ? IncomingMessageBubble(
                                message: snapshot.data![index],
                                color:
                                widget.incomingMessageColor,
                                avatarColor:
                                widget.senderAvatarColor,
                              )
                                  : OutgoingMessageBubble(
                                    (id) async {
                                  var result = await _chatService
                                      .deleteSelectedMessage(id);
                                  Navigator.of(context).pop();

                                  var message = result
                                      ? 'Message is deleted'
                                      : 'Failed to delete';
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content:
                                      Text(message)));
                                },
                                message: snapshot.data![index],
                                color:
                                widget.outgoingMessageColor,
                                avatarColor:
                                widget.receiverAvatarColor,
                              ),
                            );
                          });
                    })),
            SendMessage(
              messageCallback: (s) {
                message = s;
              },
              hintText: widget.hintText,
              onSend: () async {
                if (message != '') {
                  await _chatService.sendMessage(message);
                }
              },
              onMediaPressed: showImagePicker,
            ),
          ],
        ),
      ),
    );
  }
}