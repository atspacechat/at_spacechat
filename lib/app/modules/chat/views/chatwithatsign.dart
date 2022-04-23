import 'package:at_common_flutter/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacesignal/app/modules/contacts/views/contacts_screen.dart';
import 'package:spacesignal/app/modules/chat/views/chat_screen.dart';
import 'package:get/get.dart';
import 'package:spacesignal/utils/initial_image.dart';

class chatwithatsign extends StatefulWidget {
  final initialimage? contactImage;
  final initialimage myImage;
  final String myName;
  // static final String id = 'chatwithatsign';
  const chatwithatsign(
      {Key? key,
        this.contactImage,
        required this.myImage,
        required this.myName,
        // this.id,
        })
      : super(key: key);
  @override
  _ChatWithAtsignState createState() => _ChatWithAtsignState();
}

class _ChatWithAtsignState extends State<chatwithatsign> {
  @override
  Widget build(BuildContext context) {
    // cast
    var arg = ModalRoute.of(context)!.settings.arguments as atsignandname;
    String chatwithatsign = arg.atsign;
    String chatwithatsignname = arg.name;
    SizeConfig().init(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    SizedBox(
                      height: 15.toHeight,
                    ),
                    Container(
                      height: 70.toHeight,
                      width: 600.toWidth,
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        left: 13.toWidth,
                        bottom: 10.toHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child:Text(
                              chatwithatsignname,
                              style: GoogleFonts.quicksand(
                                fontSize: 30.toFont,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,),
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Flexible(
                            child:Text(
                              chatwithatsign,
                              style: GoogleFonts.quicksand(
                                fontSize: 18.toFont,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    SizedBox(
                      height: 10.toHeight,
                    ),
                  ])),
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
              SizedBox(
              height: MediaQuery.of(context).size.height*0.28,),//45,
              ChatScreen(
                contactImage:widget.contactImage,
                myImage: widget.myImage,
                height: (keyboardHeight == 0)
                    ? MediaQuery.of(context).size.height*0.72
                    : MediaQuery.of(context).size.height*0.72 - keyboardHeight + 20.toHeight, // /1.4
                incomingMessageColor: Color(0xFFEEEDF5),//Colors.blue[100],
                outgoingMessageColor: Color(0xFFFFF2C1),//Colors.green[100],
                isScreen: true,
              ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: (keyboardHeight==0)
                          ? 0
                          : keyboardHeight - 20.toHeight,
                      color: Colors.white,
                    )
                )
              ]
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
    Get.to(() => ContactScreen(myImage: widget.myImage,myName: widget.myName,));
    // Navigator.of(context).pushAndRemoveUntil(
    //     new MaterialPageRoute(builder: (context) => ContactScreen()),
    //         (route) => route == null);
  }

}
