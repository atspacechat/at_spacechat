import 'package:at_common_flutter/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacesignal/app/modules/contacts/views/contacts_screen.dart';
import 'package:spacesignal/app/modules/chat/views/chat_screen.dart';
import 'package:get/get.dart';

class chatwithatsign extends StatefulWidget {

  static final String id = 'chatwithatsign';
  @override
  _ChatWithAtsignState createState() => _ChatWithAtsignState();
}

class _ChatWithAtsignState extends State<chatwithatsign> {
  @override
  Widget build(BuildContext context) {
    // cast
    final String? chatWithAtSign = ModalRoute.of(context)!.settings.arguments as String;
    SizeConfig().init(context);
    return Scaffold(
      //appBar: AppBar(title: Text('Chat')),
      // TODO: Fill in the body parameter of the Scaffold
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_img.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.toHeight,//45,
                    ),
                    Container(
                      height: 80.toHeight,//68,
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            padding: EdgeInsets.only(
                              left: 12.toWidth,
                              top: 10.toHeight,
                            ),
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 45,
                            ),
                            // color: Colors.white,
                            onPressed: () {
                              _contact();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 70.toHeight,
                      width: 600.toWidth,
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        left: 13.toWidth,
                        bottom: 10.toHeight,
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child:Text(
                              chatWithAtSign!,
                              style: GoogleFonts.quicksand(
                                fontSize: 30.toFont,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,),
                              overflow: TextOverflow.visible,
                            ),
                          )],
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      height: 25.toHeight,
                    ),
                  ])),
          Container(
            alignment: Alignment.bottomCenter,
            child:ChatScreen(
              height: MediaQuery.of(context).size.height/1.4,
              incomingMessageColor: Color(0xFFEEEDF5),//Colors.blue[100],
              outgoingMessageColor: Color(0xFFFFF2C1),//Colors.green[100],
              isScreen: true,
            ),
          ),
        ],
      ),
    );






    //)),
    //       )
    // ]));
  }

  void _contact() {
    Get.to(() => ContactScreen());
    // Navigator.of(context).pushAndRemoveUntil(
    //     new MaterialPageRoute(builder: (context) => ContactScreen()),
    //         (route) => route == null);
  }

}
