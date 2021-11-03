import 'package:at_chat_flutter/models/message_model.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_contact/at_contact.dart';
import 'package:at_common_flutter/at_common_flutter.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:get/get.dart';
import 'package:spacesignal/app/modules/chat/views/chatwithatsign.dart';
import 'package:spacesignal/app/modules/home/views/home_screen.dart';
import 'package:spacesignal/utils/colors.dart';
import 'package:spacesignal/utils/text_strings.dart';
import 'package:spacesignal/app/modules/contacts/views/error_screen.dart';
// import 'package:spacesignal/chat/chatwithatsign.dart';
// import 'package:spacesignal/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacesignal/app/modules/contacts/views/custom_list_tile.dart';
import 'package:spacesignal/app/modules/chat/controllers/chat_service.dart';
import 'package:spacesignal/app/modules/chat/controllers/init_chat_service.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:spacesignal/utils/constants.dart';
import 'package:spacesignal/app/modules/contacts/controllers/init_contacts_service.dart';
// import 'package:spacesignal/chatlist/add_contacts.dart' as a;
import 'package:spacesignal/app/modules/contacts/controllers/contact_service.dart';
// import 'package:spacesignal/utils/init_chat_service.dart';
import 'package:spacesignal/app/modules/contacts/views/blocked_contact.dart';



import 'dart:io';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart' as at_commons;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:spacesignal/utils/constants.dart';
import 'package:at_commons/at_commons.dart';

import 'package:spacesignal/app/modules/contacts/views/add_contacts.dart';




class ContactScreen extends StatefulWidget {
  static final String id = 'contactscreen';
  final BuildContext? context;

  final ValueChanged<List<AtContact>>? selectedList;
  final bool asSelectionScreen;
  final bool asSingleSelectionScreen;
  final Function? saveGroup, onSendIconPressed;

  const ContactScreen(
      {Key? key,
        this.selectedList,
        this.context,
        this.asSelectionScreen = false,
        this.asSingleSelectionScreen = false,
        this.saveGroup,
        this.onSendIconPressed})
      : super(key: key);
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  // ClientSdkService? clientSdkService = ClientSdkService.getInstance();
  String? activeAtSign = '';
  GlobalKey<ScaffoldState>? scaffoldKey;
  //
  // String chatWithAtSign;
  bool showOptions = false;
  bool isEnabled = true;
  String? chatWithAtSign;

  String searchText = '';
  ContactService? _contactService;
  bool deletingContact = false;
  bool blockingContact = false;
  bool errorOcurred = false;
  late ChatService _chatService;
  final String storageKey = 'atspacesignalchatHistory.';

  List<AtContact> selectedList = [];
  @override
  void initState() {

    // getAtSignAndInitializeChat();
    scaffoldKey = GlobalKey<ScaffoldState>();
    _chatService = ChatService();
    _contactService = ContactService();
    _contactService!.initContactsService('root.atsign.org',64);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String? currentAtSign=await AtService.getInstance().getAtSign();
      // initializeContactsService(clientSdkService!.atClientServiceInstance!.atClient!,currentAtSign!,rootDomain: MixedConstants.ROOT_DOMAIN);
      var _result = await _contactService!.fetchContacts();
      print('$_result = true');
      activeAtSign=currentAtSign;
      initializeChatService(AtClientManager.getInstance(), currentAtSign!);
      // await _chatService.getChatHistory();
      _addreceiver();

      if (_result == null) {
        print('_result = true');
        if (mounted) {
          setState(() {
            errorOcurred = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: errorOcurred
            ? ErrorScreen()
            : Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_img.png'),
              fit: BoxFit.fill,
            ),
          ),
          // padding: EdgeInsets.symmetric(
          //     horizontal: 16.toWidth, vertical: 16.toHeight),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.toHeight,
              ),
              Container(
                height: 80.toHeight,
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.only(
                        left: 12.toWidth,
                        top: 10.toHeight,
                      ),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.grey,
                        size: 45,
                      ),
                      // color: Colors.white,
                      onPressed: () {
                        Get.to(HomeScreen());
                      },
                    ),
                    IconButton(
                        padding: EdgeInsets.only(
                        left: 12.toWidth,
                          top: 10.toHeight,
                        ),
                      icon: Icon(
                        Icons.add,
                        color: Colors.grey,
                        size: 45,
                      ),
                      // color: Colors.white,
                      onPressed: () {
                        Get.to(AddContactDialog());
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 70.toHeight,
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  left: 13.toWidth,
                  bottom: 10.toHeight,
                ),
                child: Row(
                  children: <Widget>[
                    // SizedBox(
                    //   width: 10, //这里不是responsive的，可能需要后期调整
                    // ),
                    Text(
                      'Chats',
                      style: GoogleFonts.quicksand(
                        fontSize: 39.toFont,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              // 在这里加ListView之类的的东西
              SizedBox(
                height: 25.toHeight,
              ),

              // ElevatedButton(
              //   child: Text('add a contact'),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => a.AddContact(),
              //     );},),
              // ElevatedButton(
              //   child: Text('blocked contacts'),
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //       builder: (BuildContext context) => BlockedScreen(),
              //     ));},),

              Expanded(
                  child: Container(
                    // appbar下面的区域用一个expanded Container包起来
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.toHeight),
                          topRight: Radius.circular(30.toHeight),
                        ),

                      ),
                      child: StreamBuilder<List<AtContact?>>(
                        stream: _contactService!.contactStream,
                        initialData: _contactService!.contactList,
                        builder: (context, snapshot) {
                          if ((snapshot.connectionState ==
                              ConnectionState.waiting)) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if ((snapshot.data == null || snapshot.data!.isEmpty)) {
                              return Center(
                                child: Text("You don't have any chat yet"),
                              );
                            } else {
                              List<AtContact> _filteredList = [];
                              snapshot.data!.forEach((c) {
                                _filteredList.add(c!);
                              });
                              if (_filteredList.isEmpty) {
                                return Center(
                                  child: Text("You don't have any chat yet"),
                                );
                              }
                              return Container(
                                  child:
                                  ListView.separated(
                                      itemCount: _filteredList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, _) =>
                                          Divider(
                                            color: Colors.grey[300],
                                            height: 1.toHeight,
                                          ),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0.toWidth,
                                              vertical: 0),
                                          //const EdgeInsets.all(8.0),
                                          child: Slidable(
                                            actionPane:
                                            SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            secondaryActions: <Widget>[
                                              IconSlideAction(
                                                caption: "Recall",
                                                color: Colors.blue,
                                                icon: Icons.keyboard_return,
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                              contentPadding: EdgeInsets.only(
                                                                left: 0,
                                                                top: 10.toHeight,
                                                                right: 0,
                                                                bottom: 0,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                              ),
                                                              content: Container(
                                                                  height: 350.toHeight,
                                                                  width: 300.toWidth,
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          alignment: Alignment.topRight,
                                                                          height: 30.toHeight,
                                                                          width: 300.toWidth,
                                                                          child: FloatingActionButton(
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              size: 30.toFont,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            backgroundColor: Colors.white,
                                                                            mini: true,
                                                                            elevation: 0.0,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            height: 40.toHeight,
                                                                            child: Icon(Icons.warning,
                                                                              size: 60.toFont,
                                                                              color: Colors.red,)
                                                                        ),
                                                                        Container(
                                                                            padding: EdgeInsets.only(
                                                                              left: 15.0.toWidth,
                                                                              top: 10.toHeight,
                                                                              right: 15.toWidth,
                                                                              bottom: 0,
                                                                            ),
                                                                            height: 260.toHeight,
                                                                            child: Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 20.toHeight,
                                                                                    width: 50.toWidth,
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    padding: EdgeInsets.only(
                                                                                      left: 30.0.toWidth,
                                                                                      top: 0,
                                                                                      right: 30.toWidth,
                                                                                      bottom: 0,
                                                                                    ),
                                                                                    height: 170.toHeight,
                                                                                    width: 400.toWidth,
                                                                                    child: Text(
                                                                                      "All your previous messages will be recalled. Do you really want to recall your messages?",
                                                                                      style: TextStyle(
                                                                                          fontSize: 15.toFont,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black),
                                                                                      maxLines: null,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 10.toHeight,
                                                                                    width: 320.toWidth,
                                                                                  ),
                                                                                  Container(
                                                                                      height: 50.toHeight,
                                                                                      width: 400.toWidth,
                                                                                      child: Row(children: <Widget>[
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                                elevation: 0.0,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius:
                                                                                                  BorderRadius.circular(20.0),
                                                                                                ),
                                                                                                color: Colors.white,
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "No",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Color(0xFF8F8E94),
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                        Container(
                                                                                          width: 5.toWidth,
                                                                                          height: 80.toHeight,
                                                                                        ),
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(20)),
                                                                                              boxShadow: <BoxShadow>[
                                                                                                BoxShadow(
                                                                                                    color: Colors.grey
                                                                                                        .withOpacity(0.1),
                                                                                                    blurRadius: 0.5,
                                                                                                    offset: Offset(0.0, 1)),
                                                                                              ],
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                              //MaterialButton(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(
                                                                                                        20.0),
                                                                                                    side: BorderSide(
                                                                                                        color:
                                                                                                        Colors.red)),
                                                                                                elevation: 5.0,
                                                                                                color: Colors.red, //Color(0xFF584797)
                                                                                                onPressed: () async {

                                                                                                  // await ChatService().deleteMessages(_filteredList[index].atSign.toString());

                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Yes, recall",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                      ]))
                                                                                ]))
                                                                      ]))));

                                                },
                                              ),
                                              IconSlideAction(
                                                caption: TextStrings().block,
                                                // color: ColorConstants.inputFieldColor,
                                                color:Colors.grey[300],
                                                icon: Icons.block,
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                              contentPadding: EdgeInsets.only(
                                                                left: 0,
                                                                top: 10.toHeight,
                                                                right: 0,
                                                                bottom: 0,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                              ),
                                                              content: Container(
                                                                  height: 350.toHeight,
                                                                  width: 300.toWidth,
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          alignment: Alignment.topRight,
                                                                          height: 30.toHeight,
                                                                          width: 300.toWidth,
                                                                          child: FloatingActionButton(
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              size: 30.toFont,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            backgroundColor: Colors.white,
                                                                            mini: true,
                                                                            elevation: 0.0,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            height: 40.toHeight,
                                                                            child: Icon(Icons.warning,
                                                                              size: 60.toFont,
                                                                              color: Colors.red,)
                                                                        ),
                                                                        Container(
                                                                            padding: EdgeInsets.only(
                                                                              left: 15.0.toWidth,
                                                                              top: 10.toHeight,
                                                                              right: 15.toWidth,
                                                                              bottom: 0,
                                                                            ),
                                                                            height: 260.toHeight,
                                                                            child: Column(
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    height: 20.toHeight,
                                                                                    width: 50.toWidth,
                                                                                  ),
                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    padding: EdgeInsets.only(
                                                                                      left: 30.0.toWidth,
                                                                                      top: 0,
                                                                                      right: 30.toWidth,
                                                                                      bottom: 0,
                                                                                    ),
                                                                                    height: 170.toHeight,
                                                                                    width: 400.toWidth,
                                                                                    child: Text(
                                                                                      "This contact will be deleted and you will never receive any signal from this contact. Do you really want to block this contact?",
                                                                                      style: TextStyle(
                                                                                          fontSize: 15.toFont,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black),
                                                                                      maxLines: null,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    height: 10.toHeight,
                                                                                    width: 320.toWidth,
                                                                                  ),
                                                                                  Container(
                                                                                      height: 50.toHeight,
                                                                                      width: 400.toWidth,
                                                                                      child: Row(children: <Widget>[
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                                elevation: 0.0,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius:
                                                                                                  BorderRadius.circular(20.0),
                                                                                                ),
                                                                                                color: Colors.white,
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "No",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Color(0xFF8F8E94),
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                        Container(
                                                                                          width: 5.toWidth,
                                                                                          height: 80.toHeight,
                                                                                        ),
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(20)),
                                                                                              boxShadow: <BoxShadow>[
                                                                                                BoxShadow(
                                                                                                    color: Colors.grey
                                                                                                        .withOpacity(0.1),
                                                                                                    blurRadius: 0.5,
                                                                                                    offset: Offset(0.0, 1)),
                                                                                              ],
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                              //MaterialButton(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(
                                                                                                        20.0),
                                                                                                    side: BorderSide(
                                                                                                        color:
                                                                                                        Colors.red)),
                                                                                                elevation: 5.0,
                                                                                                color: Colors.red, //Color(0xFF584797)
                                                                                                onPressed: () async {
                                                                                                  // _deletechathistory();
                                                                                                  await _contactService!.blockUnblockContact(contact: _filteredList[index], blockAction: true);
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Yes, block",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                      ]))
                                                                                ]))
                                                                      ]))));

                                                },
                                              ),
                                              IconSlideAction(
                                                caption: TextStrings().delete,
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                              contentPadding: EdgeInsets.only(
                                                                left: 0,
                                                                top: 10.toHeight,
                                                                right: 0,
                                                                bottom: 0,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                                              ),
                                                              content: Container(
                                                                  height: 350.toHeight,
                                                                  width: 300.toWidth,
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                        Container(
                                                                          alignment: Alignment.topRight,
                                                                          height: 30.toHeight,
                                                                          width: 300.toWidth,
                                                                          child: FloatingActionButton(
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              size: 30.toFont,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            backgroundColor: Colors.white,
                                                                            mini: true,
                                                                            elevation: 0.0,
                                                                          ),
                                                                        ),
                                                                        // ),
                                                                        Container(
                                                                            height: 40.toHeight,
                                                                            child: Icon(Icons.warning,
                                                                              size: 60.toFont,
                                                                              color: Colors.red,)
                                                                        ),

                                                                        Container(
                                                                            padding: EdgeInsets.only(
                                                                              left: 15.0.toWidth,
                                                                              top: 10.toHeight,
                                                                              right: 15.toWidth,
                                                                              bottom: 0,
                                                                            ),
                                                                            height: 260.toHeight,
                                                                            child: Column(
                                                                              //新建一个Column来放文字信息，发件人名字和最近信息
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.center, //左对齐
                                                                                children: [
                                                                                  Container(
                                                                                    height: 20.toHeight,
                                                                                    width: 50.toWidth,
                                                                                  ),

                                                                                  Container(
                                                                                    alignment: Alignment.center,
                                                                                    padding: EdgeInsets.only(
                                                                                      left: 30.0.toWidth,
                                                                                      top: 0,
                                                                                      right: 30.toWidth,
                                                                                      bottom: 0,
                                                                                    ),
                                                                                    height: 170.toHeight,
                                                                                    width: 400.toWidth,
                                                                                    child: Text(
                                                                                      "This contact will be deleted. Do you really want to delete?",
                                                                                      style: TextStyle(
                                                                                          fontSize: 15.toFont,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black),//Color(0xFF584797)
                                                                                      maxLines: null,
                                                                                    ),
                                                                                  ),

                                                                                  Container(
                                                                                    height: 10.toHeight,
                                                                                    width: 320.toWidth,
                                                                                  ),
                                                                                  Container(
                                                                                      height: 50.toHeight,
                                                                                      width: 400.toWidth,
                                                                                      child: Row(children: <Widget>[
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(20)),
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                              //MaterialButton(
                                                                                                elevation: 0.0,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius:
                                                                                                  BorderRadius.circular(20.0),
                                                                                                ),
                                                                                                color: Colors.white, //:Colors.grey,
                                                                                                onPressed: () {Navigator.pop(context);},
                                                                                                child: Text(
                                                                                                  "No",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Color(0xFF8F8E94),
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                        Container(
                                                                                          width: 5.toWidth,
                                                                                          height: 80.toHeight,
                                                                                        ),
                                                                                        Container(
                                                                                            width: 130.toWidth,
                                                                                            height: 80.toHeight,
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(20)),
                                                                                              boxShadow: <BoxShadow>[
                                                                                                BoxShadow(
                                                                                                    color: Colors.grey
                                                                                                        .withOpacity(0.1),
                                                                                                    blurRadius: 0.5,
                                                                                                    offset: Offset(0.0, 1)),
                                                                                              ],
                                                                                            ),
                                                                                            child: RaisedButton(
                                                                                              //MaterialButton(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(20.0),
                                                                                                    side: BorderSide(
                                                                                                        color: Colors.red)),
                                                                                                elevation: 5.0,
                                                                                                //minWidth: 320,
                                                                                                // height: 50,
                                                                                                color: Colors.red, //Color(0xFF584797)
                                                                                                //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                                                                onPressed: () async {
                                                                                                  Navigator.pop(context);
                                                                                                  // await _contactService!.deleteAtSign(atSign: _filteredList[index].atSign);
                                                                                                },
                                                                                                child: Text(
                                                                                                  "Yes, delete",
                                                                                                  style: GoogleFonts.quicksand(
                                                                                                    fontWeight: FontWeight.w900,
                                                                                                    color: Colors.white,
                                                                                                    fontSize: 15.toFont,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ))),
                                                                                      ]))
                                                                                ]))
                                                                      ]))));



                                                },
                                              ),
                                            ],
                                            child: CustomListTile(
                                              contactService: _contactService,
                                              onTap: () {
                                                chatWithAtSign=_filteredList[index].atSign.toString();
                                                setAtsignToChatWith();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => chatwithatsign(),
                                                      settings: RouteSettings(
                                                        arguments: chatWithAtSign.toString().substring(1),
                                                      ),
                                                    ));
                                              },
                                              asSelectionTile: widget.asSelectionScreen,
                                              asSingleSelectionTile: widget.asSingleSelectionScreen,
                                              contact: _filteredList[index],
                                              selectedList: (s) {
                                                selectedList = (s != null) as List<AtContact>;
                                                widget.selectedList!(selectedList);
                                              },
                                              onTrailingPressed:
                                              widget.onSendIconPressed,
                                            ),

                                          ),
                                        );
                                      }
                                  ));

                              //   },
                              // );
                            }
                          }
                        },
                      )
                  )
              )],
          ),
          // )]),
        ));
  }
  // getAtSignAndInitContacts() async {
  //   String? currentAtSign = await ClientSdkService.getInstance().getAtSign();
  //   setState(() {
  //     activeAtSign = currentAtSign;
  //   });
  //   initializeContactsService(clientSdkService!.atClientInstance!, activeAtSign!,
  //       rootDomain: MixedConstants.ROOT_DOMAIN);
  // }

  checkForValidAtsignAndSet() {
    if (chatWithAtSign != null && chatWithAtSign!.trim() != '') {
      // TODO: Call function to set receiver's @sign
      setAtsignToChatWith();
      setState(() {
        showOptions = true;
      });
      return true;
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [Text('@sign Missing!')],
              ),
              content: Text('Please enter an @sign'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                )
              ],
            );
          });
    }
  }
  getAtSignAndInitializeChat() async {
    // String? currentAtSign = await AtService!.getAtSign();
    // setState(() {
    //   activeAtSign = activeAtSign;
    // });
    // List<String> allAtSigns = at_demo_data.allAtsigns;
    // allAtSigns.remove(activeAtSign);
    // setState(() {
    //   atSigns = allAtSigns;
    // });
    initializeChatService(
        AtClientManager.getInstance(), activeAtSign!,
        // rootDomain: 'root.atsign.wtf');
        );
    // 'root.atsign.org'
  }

  setAtsignToChatWith() {
    // print(activeAtSign);
    // print(chatWithAtSign);
    setChatWithAtSign(chatWithAtSign!);
  }

  _getSharedKeys() async {
    // await _contactService!.sync();
    //return await _contactService.getAtKeys(regex: 'cached.*cookbook');
    return await _contactService!.getAtKeys(regex: 'cached.*at_spacesignal');
  }

  _addreceiver() async {
    List<AtKey> sharedKeysList = await _getSharedKeys();
    print(sharedKeysList.length);

    sharedKeysList.forEach((element) async {
      if (element.key=="replier"){
        await _contactService!.addAtSign(context,
            atSign: element.sharedBy);
        print(element.sharedBy);

        // String chatWithAtSign=element.sharedBy;
        // setChatWithAtSign(chatWithAtSign);
        //
        // Metadata metadata = Metadata()..isCached = true;
        // AtKey atKey = AtKey()
        //     ..key = element.key
        //     ..sharedWith = element.sharedWith
        //     ..sharedBy = element.sharedBy
        //     ..metadata = metadata;
        //
        // String value = await _contactService.get(atKey);
        // print(value);
        // print(value.length);
        // String seperator="aseperatoratspacesignal";
        // int index=value.indexOf(seperator);
        // //print (index.toString());
        // String signal=value.substring(0,index);
        // //print(signal);
        // int senttime=int.parse(value.substring(index+seperator.length,value.length-1));
        //
        // await ChatService().setChatHistory(Message(
        //     message: signal,
        //     sender:activeAtSign,
        //     //time: DateTime.now().millisecondsSinceEpoch,
        //     time:senttime,
        //     type: MessageType.OUTGOING));

        await _contactService!.delete(element);
      }});
  }



}