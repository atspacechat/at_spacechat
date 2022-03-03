// import 'package:at_chat_flutter/models/message_model.dart';
// import 'package:at_chat_flutter/services/chat_service.dart';
import 'dart:typed_data';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacesignal/app/modules/chat/controllers/init_chat_service.dart';
import 'package:spacesignal/app/modules/chat/views/chatwithatsign.dart';
import 'package:spacesignal/app/modules/home/controllers/home_controller.dart';
import 'package:spacesignal/app/modules/home/views/fabbottomappbar.dart';
import 'package:spacesignal/app/modules/profile/profile.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:get/get.dart';
import 'package:spacesignal/app/modules/contacts/controllers/contact_service.dart';
import 'package:spacesignal/app/modules/chat/controllers/chat_service.dart';
import 'package:spacesignal/app/modules/chat/utils/message_model.dart';

class HomeScreen extends StatefulWidget {
  final initialimage myImage;
  final String myName;
  final String myAtSign;
  const HomeScreen(
      {Key? key,
        required this.myName,
        required this.myImage,
        required this.myAtSign,
})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//transform the color codes
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// main page, popups, menu
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AtService clientSdkService = AtService.getInstance();
  final HomeController control = Get.put<HomeController>(HomeController());
  String activeAtSign = "";
  late GlobalKey<ScaffoldState> scaffoldKey;
  ContactService? _contactService;
  ChatService? _chatService;
  var blocked_list = [];


  void reqAsignal() {
    control.wantsSignal();
    Future.delayed(const Duration(seconds: 20), (){
      if(controllerx.searchedMessageAtsign.value == "" && controllerx.serverError.value){
        controllerx.isLoading(false);
      }
    });

  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // String currentAtSign = (await clientSdkService.getAtSign())!;
      // print("current"+currentAtSign);
      controllerx.gotMessage.value = false;
      await control.readSharedByMeSignal();
      _contactService = ContactService();
      blocked_list = [];
      await _contactService!.initContactsService('root.atsign.org', 64)
          .then((result){
        blocked_list = [];
        if(_contactService!.blockContactList.length>0){
          _contactService!.blockContactList.forEach(
                  (c) {
                if(c.blocked==true){
                  blocked_list.add(c.atSign);
                }
              }
          );
        }
        print(blocked_list);
      });
      activeAtSign = widget.myAtSign;//(await clientSdkService.getAtSign())!;
      _chatService = ChatService();
      AtClientManager atClientManager = AtService.getInstance().atClientManager;
      // _chatService!.initChatService(atClientManager,activeAtSign,'root.atsign.org',64);
      initializeChatService(atClientManager, activeAtSign);
    });
    scaffoldKey = GlobalKey<ScaffoldState>();
    // print("activeatsign"+activeAtSign);
    super.initState();



  }

  //main screen, top bar, bottom bar, menu
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
            //不知道有没有多余的步骤
            children: [
              // (loadingDetails)
              // ? showLoaderDialog(context)
              // : Container(),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: ExactAssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.11,
                  ),
                  Row(
                    //这个roll里面包裹的是头像，发件人名字和信息
                    children: <Widget>[
                      SizedBox(
                        width: 30.0.toWidth,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => Profile(myAtSign: activeAtSign,myImage: widget.myImage,myName: widget.myName,));
                          },
                          child: widget.myImage,),
                      SizedBox(
                        width: 13.0.toWidth,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //新建一个Column来放文字信息，发件人名字和最近信息
                        crossAxisAlignment: CrossAxisAlignment.start, //左对齐
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                widget.myName,
                                // "test",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0.toFont,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )),
                          Container(
                            //给信息一个Container，指定一个宽度，让文字overflow
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              widget.myAtSign,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0.toFont,
                                fontWeight: FontWeight.w300,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      // if (_loading) Center(child: CircularProgressIndicator())
                    ],
                  ),
                ]),
              ),
            ]),
        floatingActionButton: Container(
            height: 70.0.toHeight,
            width: 70.0.toWidth,
            color: Colors.transparent,
            child: FittedBox(
                child: FloatingActionButton(
              onPressed: () {
                controllerx.isLoading(true);
                reqAsignal();
                showLoaderDialog(context);
              },
              backgroundColor: Colors.white,
              tooltip: 'Increment',
              child: Icon(
                Icons.wifi_tethering,
                color: Colors.deepPurple,
                size: 30.toFont,
              ),
              elevation: 2.0,
            ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          child: FABBottomAppBar(
            centerItemText: 'Explore',
            color: Colors.deepPurple,
            selectedColor: Colors.blue,
            notchedShape: CircularNotchedRectangle(),
            // onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: Icons.send, text: 'Send'),
              FABBottomAppBarItem(iconData: Icons.chat, text: 'Chats'),
            ],
            myName: widget.myName,
            myImage: widget.myImage,
          ),
        ));
  }

  final HomeController controllerx = Get.put<HomeController>(HomeController());
  // void _profilescreen() {
  //   Get.to(() => Profile());
  // }



  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: Row(children: [
          Obx(() => Container(
            child:
              controllerx.isLoading.value
              // ? CircularProgressIndicator(semanticsLabel: 'Loading')
              ? Flexible(
                child: Container(
                    height: 90.toHeight,
                    width: 300.toWidth,
                    child: Column(
                      children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        height: 30.toHeight,
                        width: 300.toWidth,
                        child: FloatingActionButton(
                          //FloatingActionButton(
                          child: Icon(
                            Icons.close,
                            size: 30.toFont,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            controllerx.isReply.value = false;
                            Navigator.pop(context);
                          },
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.white,

                          mini: true,
                          elevation: 0.0,
                        ),
                      ),
                      Row(
                          children: <Widget>[
                            Container(
                              // height: 40.toHeight,
                              // width: 40.toHeight,
                              child: CircularProgressIndicator(),
                            ),
                            Container(
                              width: 30.toWidth,
                            ),
                            Container(
                              // height: 40.toHeight,
                              child: controllerx.isReply.value
                              ? Text(
                                "Loading the chat ...",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15.toFont,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF584797)),
                                maxLines: null,
                              )
                              :Text(
                                "Searching outer space ...",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15.toFont,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF584797)),
                                maxLines: null,
                              ),
                            )
                          ]
                      ),

                      ])))

                    : (blocked_list.contains(controllerx.searchedMessageAtsign.value) || controllerx.serverError.value
                ? Flexible(
                  child: Container(
                    height: 340.toHeight,
                    width: 300.toWidth,
                    child: Column(
                      //overflow: Overflow.visible,
                      // alignment: Alignment.center,
                      children: <Widget>[
                        // Positioned(
                        //   right: 0.0,
                        // child:
                        Container(
                          alignment: Alignment.topRight,
                          height: 30.toHeight,
                          width: 300.toWidth,
                          child: FloatingActionButton(
                            //FloatingActionButton(
                            child: Icon(
                              Icons.close,
                              size: 30.toFont,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              controllerx.gotMessage.value = false;
                              Navigator.pop(context);
                            },
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.white,

                            mini: true,
                            elevation: 0.0,
                          ),
                        ),
                        // ),
                        Container(
                          height: 40.toHeight,
                          child: Text(
                            "Oops!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.patuaOne(
                              //quicksand  patuaOne
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF45377D),
                              fontSize: 25.toFont,
                            ),
                          ),
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
                                    height: 3.toHeight,
                                    width: 50.toWidth,
                                    color: Colors.grey[300],
                                  ),
                                  Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          left: 10.0.toWidth,
                                          top: 0,
                                          right: 10.toWidth,
                                          bottom: 0,
                                        ),
                                        alignment: Alignment.topLeft,
                                        child: Icon(Icons.format_quote,
                                            color: Colors.grey)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 30.0.toWidth,
                                      top: 0,
                                      right: 30.toWidth,
                                      bottom: 0,
                                    ),
                                    height: 120.toHeight,
                                    width: 400.toWidth,
                                    child: Text(
                                      'Sorry! Your message got lost in the black hole. Please try again ~',
                                      // message,
                                      style: TextStyle(
                                          fontSize: 15.toFont,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF584797)),
                                      maxLines: null,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          left: 10.0.toWidth,
                                          top: 0,
                                          right: 10.toWidth,
                                          bottom: 0,
                                        ),
                                        alignment: Alignment.bottomRight,
                                        child: Icon(Icons.format_quote,
                                            color: Colors.grey)),
                                  ),
                                  Container(
                                    height: 20.toHeight,
                                    width: 320.toWidth,
                                  ),
                                  Flexible(
                                    child: Container(
                                        height: 50.toHeight,
                                        width: 320.toWidth,
                                        child: Row(children: <Widget>[
                                          Container(
                                              width: 130.toWidth,
                                              height: 80.toHeight,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        20)),
                                              ),
                                              child: RaisedButton(
                                                //MaterialButton(
                                                  elevation: 0.0,
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(20.0),
                                                    // side: BorderSide(color: Colors.white)
                                                  ),
                                                  //elevation: 5.0,
                                                  //minWidth: 320,
                                                  // height: 50,
                                                  color: Colors.white,
                                                  //:Colors.grey,
                                                  //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                  onPressed: () {
                                                    controllerx.gotMessage.value = false;
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Nah",
                                                    style: GoogleFonts
                                                        .quicksand(
                                                      fontWeight:
                                                      FontWeight.w900,
                                                      color:
                                                      Color(0xFF8F8E94),
                                                      fontSize: 15.toFont,
                                                    ),
                                                    textAlign:
                                                    TextAlign.center,
                                                  ))),
                                          Container(
                                            width: 8.toWidth,
                                            height: 80.toHeight,
                                          ),
                                          Flexible(
                                              child: Container(
                                                  width: 130.toWidth,
                                                  height: 80.toHeight,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            20)),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                              0.1),
                                                          blurRadius: 0.5,
                                                          offset: Offset(
                                                              0.0, 1)),
                                                    ],
                                                  ),
                                                  child: RaisedButton(
                                                    //MaterialButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20.0),
                                                          side: BorderSide(
                                                              color: Color(
                                                                  0xFF584797))),
                                                      elevation: 5.0,
                                                      //minWidth: 320,
                                                      // height: 50,
                                                      color:
                                                      Color(0xFF584797),
                                                      //:Colors.grey,
                                                      //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                      onPressed: () async {
                                                        // a new search
                                                        // reqAsignal();
                                                        // controllerx.isLoading(true);
                                                        controllerx.gotMessage.value = false;
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Sure",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontWeight:
                                                          FontWeight
                                                              .w900,
                                                          color:
                                                          Colors.white,
                                                          fontSize:
                                                          15.toFont,
                                                        ),
                                                        textAlign: TextAlign
                                                            .center,
                                                      )))),
                                        ])),
                                  )
                                ]))
                      ])),
                )
                :Flexible(
                  child: Container(
                      height: 340.toHeight,
                      width: 300.toWidth,
                      child: Column(
                          //overflow: Overflow.visible,
                          // alignment: Alignment.center,
                          children: <Widget>[
                            // Positioned(
                            //   right: 0.0,
                            // child:
                            Container(
                              alignment: Alignment.topRight,
                              height: 30.toHeight,
                              width: 300.toWidth,
                              child: FloatingActionButton(
                                //FloatingActionButton(
                                child: Icon(
                                  Icons.close,
                                  size: 30.toFont,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  controllerx.gotMessage.value = false;
                                  Navigator.pop(context);
                                },
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.white,

                                mini: true,
                                elevation: 0.0,
                              ),
                            ),
                            // ),
                            Container(
                              height: 40.toHeight,
                              child: Text(
                                "You got a message!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.patuaOne(
                                  //quicksand  patuaOne
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF45377D),
                                  fontSize: 25.toFont,
                                ),
                              ),
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
                                        height: 3.toHeight,
                                        width: 50.toWidth,
                                        color: Colors.grey[300],
                                      ),
                                      Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.0.toWidth,
                                              top: 0,
                                              right: 10.toWidth,
                                              bottom: 0,
                                            ),
                                            alignment: Alignment.topLeft,
                                            child: Icon(Icons.format_quote,
                                                color: Colors.grey)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 30.0.toWidth,
                                          top: 0,
                                          right: 30.toWidth,
                                          bottom: 0,
                                        ),
                                        height: 120.toHeight,
                                        width: 400.toWidth,
                                        child: Text(
                                          '${controllerx.searchedMessage}',
                                          // message,
                                          style: TextStyle(
                                              fontSize: 15.toFont,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF584797)),
                                          maxLines: null,
                                        ),
                                      ),
                                      // controller: controller,
                                      //  onChanged: (String value)async{if(value!=''){return _hascontent=true; }},
                                      Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.0.toWidth,
                                              top: 0,
                                              right: 10.toWidth,
                                              bottom: 0,
                                            ),
                                            alignment: Alignment.bottomRight,
                                            child: Icon(Icons.format_quote,
                                                color: Colors.grey)),
                                      ),
                                      Container(
                                        height: 20.toHeight,
                                        width: 320.toWidth,
                                      ),
                                      Flexible(
                                        child: Container(
                                            height: 50.toHeight,
                                            width: 320.toWidth,
                                            child: Row(children: <Widget>[
                                              Container(
                                                  width: 130.toWidth,
                                                  height: 80.toHeight,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    // boxShadow: <BoxShadow>[
                                                    // BoxShadow(
                                                    // color: Colors.grey.withOpacity(0.1),
                                                    // blurRadius: 0.5,
                                                    // offset: Offset(0.0, 1)),
                                                    //],
                                                  ),
                                                  child: RaisedButton(
                                                      //MaterialButton(
                                                      elevation: 0.0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        // side: BorderSide(color: Colors.white)
                                                      ),
                                                      //elevation: 5.0,
                                                      //minWidth: 320,
                                                      // height: 50,
                                                      color: Colors.white,
                                                      //:Colors.grey,
                                                      //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                      onPressed: () {
                                                        // Navigator.of(context).pop(controller.text.toString());
                                                        controllerx.gotMessage.value = false;
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Discard",
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color:
                                                              Color(0xFF8F8E94),
                                                          fontSize: 15.toFont,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ))),
                                              Container(
                                                width: 8.toWidth,
                                                height: 80.toHeight,
                                              ),
                                              Flexible(
                                                  child: Container(
                                                      width: 130.toWidth,
                                                      height: 80.toHeight,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                              blurRadius: 0.5,
                                                              offset: Offset(
                                                                  0.0, 1)),
                                                        ],
                                                      ),
                                                      child: RaisedButton(
                                                          //MaterialButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xFF584797))),
                                                          elevation: 5.0,
                                                          //minWidth: 320,
                                                          // height: 50,
                                                          color:
                                                              Color(0xFF584797),
                                                          //:Colors.grey,
                                                          //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                          onPressed: () async {
                                                            // start loading
                                                            controllerx.gotMessage.value = false;
                                                            controllerx.isReply.value = true;
                                                            controllerx.isLoading(true);

                                                            // connect users and set the chat
                                                            String sender = controllerx.searchedMessageAtsign.value;
                                                            initialimage senderImage = new initialimage(atsign: sender);
                                                            var senderDetails = await _contactService!.addAtSignAndReturnImage(atSign: sender);
                                                            if (senderDetails['image']!=null){
                                                              senderImage = initialimage(image: Uint8List.fromList(senderDetails['image']),
                                                                  atsign: sender);
                                                            }

                                                            // print("check add contact "+_contactService!.getAtSignError);
                                                            String chatWithAtSign = sender;
                                                            await _notifysender(chatWithAtSign);
                                                            _chatService!.setAtsignToChatWith(chatWithAtSign,false,"",[]);
                                                            // _chatService!.getChatHistory(atsign:chatWithAtSign);
                                                            await _chatService!.getMyChatHistory();
                                                              //   .then((value){
                                                            await _chatService!.setChatHistory(
                                                                Message(
                                                                  message: controllerx.searchedMessage.value,
                                                                  sender: chatWithAtSign,
                                                                  time: DateTime.now().millisecondsSinceEpoch,
                                                                  type: MessageType.INITIAL));
                                                                    // .then((value){
                                                                    //   _contactService!.getContactDetails(sender,"").then((Map<String, dynamic> result){
                                                                    //     // setState(() {
                                                                    //     if (result["image"]!=null){
                                                                    //       senderImage = initialimage(image: Uint8List.fromList(result['image'].cast<int>()),
                                                                    //           atsign: sender);
                                                                    //     }
                                                                        // close loading


                                                                        controllerx.isLoading(false);
                                                                        controllerx.isReply.value = false;

                                                                        print(controllerx.isLoading.value);
                                                                        print(controllerx.isReply.value);
                                                                        print(controllerx.gotMessage.value);
                                                                        await Navigator.push(context, MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              chatwithatsign(
                                                                                contactImage: senderImage,
                                                                                myImage: widget.myImage,
                                                                                myName: widget.myName,),
                                                                          settings: RouteSettings(
                                                                            arguments: chatWithAtSign.toString().substring(1),
                                                                          ),
                                                                        ));
                                                              //
                                                              //   });
                                                              // });
                                                            // });



                                                          },
                                                          child: Text(
                                                            "Reply",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  15.toFont,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )))),
                                            ])),
                                      )
                                    ]))
                          ])),
                ))
          ))
          // ),
    ]));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void>_notifysender(String sender) async {
    if (sender != null) {
      String value= "aseperatoratspacesignal"+ DateTime.now().millisecondsSinceEpoch.toString();
      var metadata = Metadata()..ttr = -1;
      AtKey atKey = AtKey()
        ..key = "spacesignalreplier"
        ..metadata = metadata
        ..sharedBy = activeAtSign
        ..sharedWith = sender;
      var re = await controllerx.notifysender(atKey,value);
    }
  }
}
