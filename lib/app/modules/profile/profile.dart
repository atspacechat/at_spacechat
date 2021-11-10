import 'package:at_client_mobile/at_client_mobile.dart';
// import 'package:at_contacts_flutter/screens/blocked_screen.dart';
import 'package:spacesignal/app/modules/contacts/views/blocked_contact.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spacesignal/app/modules/home/views/onboarding.dart';
// import 'package:spacesignal/login/login.dart';
// import 'package:spacesignal/login/onboarding_screen.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:spacesignal/app/modules/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // ProgressDialog? dialog;
  // ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign = "";
  GlobalKey<ScaffoldState>? scaffoldKey;
  PanelController _pc2 = new PanelController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      String? currentAtSign = await AtService.getInstance().getAtSign();
      setState(() {
        activeAtSign = currentAtSign!;
      });
    });
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  String _test = "hello";

  Widget build(BuildContext context) {
    List<SignalSent> signals = [
      SignalSent(time: 'now', text: _test),
      SignalSent(
        time: '8:30 AM',
        text: '',
      ),
    ];

    SizeConfig().init(context);

    return Material(
        child: SlidingUpPanel(
          // panelBuilder: (scrollController)=> DefaultTabController(
          //     length: 2,
          //     child: Scaffold(
          //         appBar:AppBar(title: Icon(Icons.drag_handle),centerTitle: true,))),
            minHeight: 0,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height * 0.75,
            controller: _pc2,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
            ),
            panel: Container(
                child: Column(
                    children: [
                      Container(height:15.toHeight),
                      Container(
                          height:5.toHeight,
                          width: 50.toWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)),
                          )),
                      // color: Colors.grey[300],),
                      Container(
                          padding: const EdgeInsets.only(top:20,left:35,right: 35,bottom: 20),
                          // child:Center(
                          //   child: Column(
                          //       children: <Widget>[
                          //         // Container(
                          //         //   height: 35.toHeight,
                          //         // ),
                          //         Container(
                          child:
                          ListView.separated(
                              itemCount: 5,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, _) =>
                                  Divider(
                                    color: Colors.grey[300],
                                    height: 40.toHeight,
                                  ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: ()async{
                                      if(index==0){
                                        // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => OnboardingScreen()),(route) => route == null);
                                      }else if(index==1){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BlockedScreen()));
                                      }else if(index==2){
                                        _launchURL();
                                      }else if(index==3){
                                        _launchURL2();
                                      }else if(index==4){
                                        // Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => LoginPage()),(route) => route == null);
                                        Get.to(OnbordingScreen());
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //     content: Text(
                                        //       'You have been logged out',
                                        //       textAlign: TextAlign.center,
                                        //     )));
                                        KeyChainManager _keyChainManager =
                                        KeyChainManager.getInstance();
                                        var _atSignsList =
                                        await _keyChainManager.getAtSignListFromKeychain();
                                        _atSignsList?.forEach((element) {
                                          _keyChainManager.deleteAtSignFromKeychain(element);
                                        });

                                      }
                                    },
                                    child:Row(
                                        children: <Widget>[
                                          // Container(width: 20.toWidth),
                                          Icon(
                                            // Icons.book,
                                            settingitems[index].icon,
                                            color: Colors.black,
                                            size: 27.toFont,
                                          ),
                                          Container(width: 15.toWidth),
                                          Text(settingitems[index].text,
                                            // "User Guide",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 17.toFont,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),
                                          ),]));
                              })),])),
            // height: 35.toHeight,
            //   child:Row(
            //       children: <Widget>[
            //         Icon(
            //           Icons.book,
            //           color: Colors.black,
            //           size: 27.toFont,
            //         ),
            //         Container(width: 20.toWidth),
            //         Text("User Guide",
            //           style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 17.toFont,
            //           // fontWeight: FontWeight.w900,
            //         ),),
            //
            //       ]
            //   )
            // ),
            // Container(height: 20.toHeight,),
            // Container(
            //   height: 0.2.toHeight,
            //   color: Colors.grey,
            // ),


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
                        image: AssetImage(
                            'assets/images/profilebackground.png'),
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
                                  _goback();
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
                            child: Column(children: <Widget>[
                              SizedBox(
                                height: 10.toHeight,
                              ),
                              Row(
                                //这个roll里面包裹的是头像，发件人名字和信息
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.06,
                                    ),
                                    initialimage(atsign: activeAtSign),
                                    // CircleAvatar(
                                    //   radius: 30.0,
                                    //   backgroundImage:
                                    //       AssetImage("assets/images/meee.png"),
                                    // ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.03,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      //新建一个Column来放文字信息，发件人名字和最近信息
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start, //左对齐
                                      children: [
                                        Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.66,
                                            child: Text(
                                              activeAtSign.substring(1),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23.0.toFont,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        // SizedBox(
                                        //   height: 3.0,
                                        // ),
                                        // Container(
                                        //     width: 60,
                                        //     height: 25,
                                        //     decoration: BoxDecoration(
                                        //       color: Colors.transparent,
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(20)),
                                        //       /* boxShadow: <BoxShadow>[
                                        //               BoxShadow(
                                        //                   color: Colors.grey.withOpacity(0.1),
                                        //                 //  color: Colors.transparent,
                                        //                   blurRadius: 0.5,
                                        //                   offset: Offset(0.0, 1)),
                                        //             ],*/
                                        //     ),
                                        //     child: FlatButton(
                                        //         //RaisedButton(//MaterialButton(
                                        //         shape: RoundedRectangleBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     20.0),
                                        //             side: BorderSide(
                                        //                 color:
                                        //                     Colors.grey[400])),
                                        //         //elevation: 5.0,
                                        //         //minWidth: 320,
                                        //         // height: 50,
                                        //         color: Colors
                                        //             .transparent, //:Colors.grey,
                                        //         //padding: EdgeInsets.symmetric(vertical: 15.0),
                                        //         onPressed: () {},
                                        //         child: Text(
                                        //           "Edit",
                                        //           style: GoogleFonts.quicksand(
                                        //             // fontWeight: FontWeight.w900,
                                        //             color: Colors.grey[400],
                                        //             fontSize: 15,
                                        //           ),
                                        //           textAlign: TextAlign.center,
                                        //         ))
                                        // ),
                                      ],
                                    ),
                                    // Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.end,
                                    //     children: <Widget>[
                                    Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.13,
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          padding: EdgeInsets.only(
                                            right: 27.toWidth,
                                            //top: 10,
                                          ),
                                          icon: Icon(
                                            // Icons.logout,
                                            Icons.settings,
                                            color: Colors.grey,
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
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 5.toHeight,
                              ),
                              //height: double.maxFinite,//500,
                              child: ListView.builder(
                                  itemCount: signals.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    final SignalSent ?chat = signals[index];
                                    if (signals[index].text!.isNotEmpty) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          right: 1.0.toWidth,
                                          left: 1.0.toWidth,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.0.toWidth,
                                          vertical: 8.0.toHeight,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            //color: chat.unread ? Color(0xFFFEF9EB) : Colors.white60,
                                            //设置聊天框的边框弧度和底色
                                            border: new Border.all(
                                              width: 0.2.toWidth,
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20.0),
                                              topLeft: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight: Radius.circular(
                                                  20.0),
                                            )),
                                        //这个Container里面用来设置边框等信息

                                        child: Row(
                                          //这个ROll里面包含了时间，和另一个roll（头像，发件人，信息）
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween, //让两个roll分开展示
                                          children: [
                                            Row(
                                              //这个roll里面包裹的是头像，发件人名字和信息
                                              children: <Widget>[
                                                Column(
                                                  //新建一个Column来放文字信息，发件人名字和最近信息
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  //左对齐
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                20)),
                                                        color: Color(0xFF584797)
                                                            .withOpacity(0.2),
                                                      ),
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.65,
                                                      child: Container(
                                                          padding: EdgeInsets
                                                              .all(
                                                              15),
                                                          child: Text(
                                                            chat!.text!,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF45377D),
                                                              fontSize: 14.0
                                                                  .toFont,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                            ),
                                                            // overflow: TextOverflow.ellipsis,
                                                          )),
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 20.toWidth,
                                                            top: 7.toHeight),
                                                        child: Text(
                                                          chat.time!,
                                                          //"now",
                                                          style: TextStyle(
                                                            fontSize: 13.0
                                                                .toFont,
                                                            color: Colors.grey,
                                                            // fontWeight: FontWeight.bold,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 20.toHeight,
                                                ),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: [
                                                    FlatButton(
                                                      //RaisedButton(//MaterialButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20.0),
                                                            side: BorderSide(
                                                                color: Color(0xff311B92))
                                                        ),
                                                        //elevation: 5.0,
                                                        minWidth: 60.toWidth,
                                                        height: 25.toHeight,
                                                        color: Colors
                                                            .transparent,
                                                        onPressed: () {
                                                          showLoaderDialog(
                                                              context);
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1), () {
                                                            // Navigator.pushReplacement(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (BuildContext context) => this.widget));
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              _test = '';
                                                            });
                                                          });
                                                        },
                                                        child: Text(
                                                          "Recall",
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight: FontWeight
                                                                .w700,
                                                            color: Color(
                                                                0xFF45377D),
                                                            fontSize: 13.toFont,
                                                          ),
                                                          textAlign: TextAlign
                                                              .center,
                                                        )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      );
                                    } else {
                                      if (index == 0) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            top: 100.toHeight,
                                            bottom: 0,
                                            right: 30.0.toWidth,
                                            left: 30.0.toWidth,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "You haven't sent any signals yet",
                                                style: TextStyle(
                                                  color: Colors.deepPurple[900],
                                                  fontSize: 17.0.toFont,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Container(
                                                height: 15.toHeight,
                                              ),
                                              Text(
                                                "You can start to build connections with others by sending signals.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0.toFont,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                height: 25.toHeight,
                                              ),
                                              FlatButton(
                                                //RaisedButton(//MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                      side: BorderSide(
                                                          color: Color(0xff311B92))),
                                                  //elevation: 5.0,
                                                  minWidth: 250.toWidth,
                                                  height: 50.toHeight,
                                                  color: Colors
                                                      .deepPurple[900],
                                                  //:Colors.grey,
                                                  //padding: EdgeInsets.symmetric(vertical: 15.0),
                                                  onPressed: () {
                                                    _goback();
                                                  },
                                                  child: Text(
                                                    "Send signals now",
                                                    style: GoogleFonts
                                                        .quicksand(
                                                      fontWeight: FontWeight
                                                          .w900,
                                                      color: Colors.white,
                                                      fontSize: 15.toFont,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ))
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }
                                  }),
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
    settingitem(
      icon: Icons.book,
      text: "User Guide",
    ),
    settingitem(
      icon: Icons.list_alt,
      text: "Blocked Contacts",
    ),
    settingitem(
      icon: Icons.supervised_user_circle,
      text: "About Us",
    ),
    settingitem(
      icon: Icons.email,
      text: "Follow Us",
    ),
    settingitem(
      icon: Icons.logout,
      text: "Log Out",
    ),


  ];
  void _goback() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => route == null);
  }


  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7.toWidth),
              child: Text("Recalling...")),
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

class settingitem {
  IconData? icon;
  String text; // can change to type DateTime to get a better function, ala I have time

  settingitem({
    this.icon,
    required this.text,
  });
}
_launchURL() async {
  await FlutterWebBrowser.openWebPage(
    url: "https://wavi.ng/@spacesignal",
    customTabsOptions: CustomTabsOptions(
      toolbarColor: Colors.deepPurple,
      addDefaultShareMenuItem: true,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
    safariVCOptions: SafariViewControllerOptions(
      barCollapsingEnabled: true,
      preferredBarTintColor: Colors.green,
      preferredControlTintColor: Colors.amber,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationCapturesStatusBarAppearance: true,
    ),
  );//, androidToolbarColor: Colors.deepPurple);
}
_launchURL2() async {
  await FlutterWebBrowser.openWebPage(
    url: "https://www.instagram.com/spacesignalapp/",
    customTabsOptions: CustomTabsOptions(
      toolbarColor: Colors.deepPurple,
      addDefaultShareMenuItem: true,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
    safariVCOptions: SafariViewControllerOptions(
      barCollapsingEnabled: true,
      preferredBarTintColor: Colors.green,
      preferredControlTintColor: Colors.amber,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationCapturesStatusBarAppearance: true,
    ),
  );//, androidToolbarColor: Colors.deepPurple);
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

/*

class RecentSignalSent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child:Container(
    margin: EdgeInsets.only(top: 20,),
        child: ListView.builder(
            itemCount: signals.length,
            itemBuilder: (BuildContext context, int index) {
              final SignalSent chat = signals[index];
              if(chat.text.isNotEmpty) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    right: 1.0,
                    left: 1.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      //color: chat.unread ? Color(0xFFFEF9EB) : Colors.white60,
                      //设置聊天框的边框弧度和底色
                      border: new Border.all(
                        width: 0.2,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  //这个Container里面用来设置边框等信息

                  child: Row(
                    //这个ROll里面包含了时间，和另一个roll（头像，发件人，信息）
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, //让两个roll分开展示
                    children: [
                      Row(
                        //这个roll里面包裹的是头像，发件人名字和信息
                        children: <Widget>[

                          SizedBox(
                            width: 0.0,
                          ),
                          Column(
                            //新建一个Column来放文字信息，发件人名字和最近信息
                            crossAxisAlignment:
                            CrossAxisAlignment.start, //左对齐
                            children: [

                              SizedBox(
                                height: 0.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.deepPurple[100],
                                ),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.65,
                                child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      chat.text,
                                      style: TextStyle(
                                        color: Colors.deepPurple[900],
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // overflow: TextOverflow.ellipsis,
                                    )),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 20, top: 7),
                                  child: Text(
                                    chat.time,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: FlatButton( //RaisedButton(//MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: BorderSide(
                                      color: Colors.deepPurple[900])),
                              //elevation: 5.0,
                              minWidth: 60,
                              height: 25,
                              color: Colors.transparent,
                              //:Colors.grey,
                              //padding: EdgeInsets.symmetric(vertical: 15.0),
                              onPressed: () {
                                async()
                               //this.setState(() {_signalsent = '';});
                                /*Navigator.pushReplacement(
                                         context,
                                         MaterialPageRoute(
                                              builder: (BuildContext context) => this));;*/
                              },
                              child: Text(
                                "Recall",
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.deepPurple[900],
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ))
                      ),
                    ],
                  ),
                );
              }else{
                return null;}}),
      ),
    ));
  }

static String _signalsent = "Hello how are you?";

  List<SignalSent> signals = [
    SignalSent(time:'now', text:_signalsent),
    //SignalSent('8:30 AM', ''),

  ];

}
*/
