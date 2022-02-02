import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:at_contacts_flutter/screens/blocked_screen.dart';
import 'package:spacesignal/app/modules/contacts/views/blocked_contact.dart';
import 'package:spacesignal/app/modules/home/controllers/home_controller.dart';
import 'package:spacesignal/app/modules/home/views/onboarding.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:spacesignal/app/modules/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  initialimage myImage = new initialimage();
  String myName = "me";
  String myAtSign = "";
  Profile(
      {Key? key,
        required this.myName,
        required this.myImage,
        required this.myAtSign
      })
      : super(key: key);

  // @override
  // _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends StatelessWidget {
  // ProgressDialog? dialog;
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();

  GlobalKey<ScaffoldState>? scaffoldKey;
  PanelController _pc2 = new PanelController();

  // @override
  // void initState() {
  //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
  //     String? currentAtSign = await AtService.getInstance().getAtSign();
  //     setState(() {
  //       activeAtSign = currentAtSign!;
  //     });
  //   });
  //   scaffoldKey = GlobalKey<ScaffoldState>();
  //   super.initState();
  // }

  @override
  final HomeController controller = Get.put<HomeController>(HomeController());

  Widget build(BuildContext context) {
    String activeAtSign = myAtSign;

    SizeConfig().init(context);

    return Material(
        child: SlidingUpPanel(
            // panelBuilder: (scrollController)=> DefaultTabController(
            //     length: 2,
            //     child: Scaffold(
            //         appBar:AppBar(title: Icon(Icons.drag_handle),centerTitle: true,))),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            controller: _pc2,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            panel: Container(
                child: Column(children: [
              Container(height: 15.toHeight),
              Container(
                  height: 5.toHeight,
                  width: 50.toWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
              // color: Colors.grey[300],),
              Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 35, right: 35, bottom: 20),
                  // child:Center(
                  //   child: Column(
                  //       children: <Widget>[
                  //         // Container(
                  //         //   height: 35.toHeight,
                  //         // ),
                  //         Container(
                  child: ListView.separated(
                      itemCount: 4,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, _) => Divider(
                            color: Colors.grey[300],
                            height: 40.toHeight,
                          ),
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              // if (index == 0) {
                              //   // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => OnboardingScreen()),(route) => route == null);
                              // } else
                                if (index == 0) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlockedScreen()));
                              } else if (index == 1) {
                                _launchURL();
                              } else if (index == 2) {
                                _launchURL2();
                              } else if (index == 3) {
                                // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => LoginPage()),(route) => route == null);

                                KeyChainManager _keyChainManager =
                                    KeyChainManager.getInstance();
                                var _atSignsList = await _keyChainManager
                                    .getAtSignListFromKeychain();
                                _atSignsList?.forEach((element) {
                                  _keyChainManager
                                      .deleteAtSignFromKeychain(element);
                                });
                                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  //   content: Text(
                                  //   'You have been logged out',
                                  //   textAlign: TextAlign.center,
                                  //   )));

                                Get.to(() => OnbordingScreen());

                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text(
                                //       'You have been logged out',
                                //       textAlign: TextAlign.center,
                                //     )));
                              }
                            },
                            child: Row(children: <Widget>[
                              // Container(width: 20.toWidth),
                              Icon(
                                // Icons.book,
                                settingitems[index].icon,
                                color: Colors.black,
                                size: 27.toFont,
                              ),
                              Container(width: 15.toWidth),
                              Text(
                                settingitems[index].text,
                                // "User Guide",
                                style: GoogleFonts.quicksand(
                                    fontSize: 17.toFont,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ]));
                      })),
            ])),
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              backgroundColor: Colors.grey[700],
              // body: SafeArea(
              body: Stack(
                //不知道有没有多余的步骤
                children: [
                  //]<Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('assets/images/profilebackground.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 35.toHeight,
                        ),
                        Container(
                          height: 68.toHeight,
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              //]<Widget>[
                              IconButton(
                                padding: EdgeInsets.only(
                                  left: 15.toWidth,
                                  top: 10.toHeight,
                                ),
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.grey,
                                  size: 45.toFont,
                                ),
                                // color: Colors.white,
                                onPressed: () {
                                  final HomeController controllerx = Get.put<HomeController>(HomeController());
                                  controllerx.gotMessage.value = false;
                                  Get.to(()=>HomeScreen(myImage: myImage,myName: myName,));
                                },
                              )
                            ],
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          width: double.infinity,
                          color: Colors.transparent,
                          //alignment: Alignment(-0.4,-0.8),
                          child: Container(
                            //width: 400,
                            width: double.infinity,
                            height: 85.toHeight,
                            color: Colors.transparent,
                            // child: Row(
                            //     //这个ROll里面包含了时间，和另一个roll（头像，发件人，信息）
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween, //让两个roll分开展示
                            //     children: [
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10.toHeight,
                                ),
                                Row(
                                    //这个roll里面包裹的是头像，发件人名字和信息
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                      ),
                                      // initialimage(atsign: activeAtSign),
                                      myImage,
                                      // CircleAvatar(
                                      //   radius: 30.0,
                                      //   backgroundImage:
                                      //       AssetImage("assets/images/meee.png"),
                                      // ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        //新建一个Column来放文字信息，发件人名字和最近信息
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start, //左对齐
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.66,
                                              child: Text(
                                                // activeAtSign.substring(1),
                                                myName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23.0.toFont,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ],
                                      ),

                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.13,
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            padding: EdgeInsets.only(
                                              right: 27.toWidth,
                                              //top: 10,
                                            ),
                                            icon: Icon(
                                              // Icons.logout,
                                              Icons.settings,
                                              color: Colors.grey[300],
                                              size: 35.toFont,
                                            ),
                                            // color: Colors.white,
                                            onPressed: () {
                                              // _settings();
                                              _pc2.open();
                                            },
                                          )),
                                    ]),
                                //width: double.maxFinite,
                                //  alignment: Alignment.centerRight,
                                //   child: Icon(Icons.settings,color: Colors.white,size:20,),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 10.toHeight,
                        ),
                        Container(
                            height: 47.toHeight,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                              left: 25.toWidth,
                              //top: 10,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(
                                        left: 30.toWidth,
                                        //top: 10,
                                      ),
                                      child: Text(
                                        "Sent",
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 17.toFont,
                                        ),
                                        textAlign: TextAlign.left,
                                      )),
                                  Container(
                                    height: 3.toHeight,
                                  ),
                                  Container(
                                    width: 100.toFont,
                                    height: 4.toHeight,
                                    color: Colors.yellow,
                                  ),
                                  Container(
                                    height: 10.toHeight,
                                  ),
                                ])),
                        // Container(
                        //   child: RecentSignalSent(),
                        // ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 5.toHeight,
                              ),
                              child: Obx(() => ListView.builder(
                                  itemCount: controller.signalByMelist.length,
                                  itemBuilder: (context, index) {
                                    var _item =
                                        controller.signalByMelist[index];
                                    String key = _item['unisignal'];
                                    return ListTile(
                                      trailing: IconButton(
                                        icon:
                                            Icon(Icons.delete_forever_outlined),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: 'Delete Message !',
                                            titleStyle: GoogleFonts.patuaOne(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.deepPurple,
                                              fontSize: 25,
                                            ),
                                            middleText:
                                            'Are you sure you want to delete this message from outer space?',
                                            onConfirm: () {
                                              controller.recallSignal(key);
                                              Navigator.pop(context);
                                            },
                                            textConfirm: 'Delete',
                                            textCancel: 'Cancel',
                                            buttonColor: Colors.deepPurple,
                                            cancelTextColor:Colors.grey,
                                            confirmTextColor: Colors.white,
                                          );
                                        },
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "${_item['Message']}",
                                          style: TextStyle(
                                            color: Color(0xFF45377D),
                                            fontSize: 14.0.toFont,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                //),
              ),
            )));
  }

  List<settingitem> settingitems = [
    // settingitem(
    //   icon: Icons.book,
    //   text: "User Guide",
    // ),
    settingitem(
      icon: Icons.list_alt,
      text: "Blocked Contacts",
    ),
    settingitem(
      icon: Icons.supervised_user_circle,
      text: "About Us",
    ),
    settingitem(
      icon: Icons.camera_alt,
      text: "Follow Us",
    ),
    settingitem(
      icon: Icons.logout,
      text: "Log Out",
    ),
  ];
}

class settingitem {
  IconData? icon;
  String
      text; // can change to type DateTime to get a better function, ala I have time

  settingitem({
    this.icon,
    required this.text,
  });
}

_launchURL() async {
  await FlutterWebBrowser.openWebPage(
    url: "https://wavi.ng/@spacechat",
    customTabsOptions: CustomTabsOptions(
      toolbarColor: Color(0xFF45377D),
      addDefaultShareMenuItem: true,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
    safariVCOptions: SafariViewControllerOptions(
      barCollapsingEnabled: true,
      preferredBarTintColor: Color(0xFF45377D),
      preferredControlTintColor: Colors.white,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationCapturesStatusBarAppearance: true,
    ),
  ); //, androidToolbarColor: Colors.deepPurple);
}

_launchURL2() async {
  await FlutterWebBrowser.openWebPage(
    url: "https://www.instagram.com/at_spacechat_app/",
    customTabsOptions: CustomTabsOptions(
      toolbarColor: Color(0xFF45377D),
      addDefaultShareMenuItem: true,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
    safariVCOptions: SafariViewControllerOptions(
      barCollapsingEnabled: true,
      preferredBarTintColor: Color(0xFF45377D),
      preferredControlTintColor: Colors.white,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationCapturesStatusBarAppearance: true,
    ),
  ); //, androidToolbarColor: Colors.deepPurple);
}

class SignalSent {
  //final User sender;
  String? time;
  String? text;

  SignalSent({
    // this.sender,
    this.time,
    this.text,
  });
}