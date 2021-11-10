import 'package:at_common_flutter/services/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:spacesignal/app/modules/home/views/fabbottomappbar.dart';
import 'package:spacesignal/app/modules/home/views/signal_by_me.dart';
import 'package:spacesignal/app/modules/home/views/uni_signal.dart';
import 'package:spacesignal/app/modules/profile/profile.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:get/get.dart';
import 'package:spacesignal/app/modules/contacts/controllers/contact_service.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home';
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

  // var _contactService = ContactService();
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign = "";
  late GlobalKey<ScaffoldState> scaffoldKey;
  // SignalService _signalService = SignalService();
  // String message;
  int presstime = 1;
  ContactService? _contactService;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String? currentAtSign = await clientSdkService.getAtSign();
      setState(() {
        activeAtSign = currentAtSign!;
      });
      // _signalService.initSignalService(clientSdkService.atClientServiceInstance.atClient, activeAtSign,'root.atsign.org',64);
      // initializeContactsService(clientSdkService.atClientServiceInstance.atClient,activeAtSign,rootDomain: 'root.atsign.org');
    });

    _contactService = ContactService();
    _contactService!.initContactsService('root.atsign.wtf',64);


    scaffoldKey = GlobalKey<ScaffoldState>();
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
                            _profilescreen();
                          },
                          child: initialimage(atsign: activeAtSign)),
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
                                activeAtSign.substring(1),
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
                              activeAtSign,
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
                Get.to(UniSignal());
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
            centerItemText: 'Search',
            color: Colors.deepPurple,
            selectedColor: Colors.blue,
            notchedShape: CircularNotchedRectangle(),
            // onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: Icons.send, text: 'Send'),
              FABBottomAppBarItem(iconData: Icons.chat, text: 'Chats'),
            ],
          ),
        ));
  }

  void _profilescreen() {
    Get.to(Profile());
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7.toWidth),
              child: Text("Searching...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
