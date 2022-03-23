import 'dart:async';
import 'dart:typed_data';

import 'package:at_server_status/at_server_status.dart';
import 'package:flutter/material.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacesignal/app/modules/contacts/controllers/contact_service.dart';
import 'package:spacesignal/app/modules/home/views/home_screen.dart';
import 'package:spacesignal/utils/constants.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:spacesignal/utils/initial_image.dart';
import '../../../../sdk_service.dart';
import 'package:get/get.dart';
import 'package:at_client/src/service/notification_service_impl.dart';

class OnbordingScreen extends StatefulWidget {
  // String? snackBarText;
  // OnbordingScreen({Key? key,
  //   this.snackBarText,
  // }) : super(key: key);

  @override
  OnbordingScreenState createState() => OnbordingScreenState();
}

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

class OnbordingScreenState extends State<OnbordingScreen> {
  late AtClientPreference atClientPrefernce;
  final _logger = AtSignLogger('Spacesignal');
  AtService clientSdkService = AtService.getInstance();
  Map<dynamic, dynamic> mydetails = new Map<dynamic, dynamic>();
  initialimage myImage = new initialimage();
  String myName = "";
  Controller1 c = Get.put(Controller1());
  // initialimage myImage = new initialimage();
  // String myName = "";

  @override
  void initState() {
    AtService.getInstance()
        .getAtClientPreference()
        .then((AtClientPreference value) => atClientPrefernce = value);
    c.isLoading.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Color color1 = HexColor("45377D");
    Color color3 = HexColor("FFFFFF");

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => Stack(
            children:[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.07),
                        BlendMode.hardLight), //dstATop
                    image: AssetImage("assets/images/loginpage.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Obx(() => Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                color: (c.isLoading==true)
                ?Colors.black.withOpacity(0.35)
                :Colors.transparent,
                child: (c.isLoading==true)
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      child: Text(
                    "Loading your planet ...",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                    fontSize: 15.toFont,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                    maxLines: null,
                    )
                    )
                    ]
                    )
                : Container())),

              Obx(() => Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child:SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0.toWidth,
                    vertical: 55.0.toHeight,
                  ),
                  child: (c.isLoading==true)
                    ? Container()
                    :Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(height: 95.0.toHeight),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 23.toWidth,
                            ),
                            child: Container(
                              child: Image(
                                image: AssetImage('assets/images/logo_new.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 110.toHeight,
                          ),
                          Container(
                            //width: double.infinity,
                            // height: 120.toHeight,
                            padding: EdgeInsets.symmetric(
                              vertical: 5.toHeight,
                              horizontal: 10.toWidth,
                            ),
                            child: Column(
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    Onboarding(
                                        domain: MixedConstants.rootDomain,
                                        context: context,
                                        atClientPreference: atClientPrefernce,
                                        appColor: color1,
                                        onboard:
                                            (Map<String?, AtClientService> value,
                                            String? atsign) async{
                                          c.isLoading.value = true;
                                          AtService.getInstance().atClientServiceMap = value;
                                          _logger.finer('Successfully onboarded $atsign');
                                          clientSdkService.currentAtsign =  atsign;

                                          // Future<AtStatus> getAtStatus(atSign) async {
                                          //   AtStatus atStatus;
                                          //   AtStatusImpl atStatusImpl;
                                          //   // AtStatus atStatus = await atStatusImpl.get(atSign);
                                          //   // AtSignStatus atSignStatus = atStatus.status();
                                          //   // int httpStatus = atStatus.httpStatus();
                                          //   atStatusImpl = AtStatusImpl();
                                          //   atStatus = await atStatusImpl.get(atSign);
                                          //   print('status for : $atSign');
                                          //   print('rootStatus: ${atStatus.rootStatus}');
                                          //   print('serverStatus: ${atStatus.serverStatus}');
                                          //   print('status: ${atStatus.status()}');
                                          //   print('httpStatus: ${atStatus.httpStatus()}');
                                            // if(atStatus.rootStatus.toString() != "RootStatus.found" ||
                                            //     atStatus.serverStatus.toString()!="ServerStatus.activated" ||
                                            //     atStatus.status().toString()!="AtSignStatus.activated" ||
                                            //     atStatus.httpStatus().toString()!="200")
                                            // {
                                            // await Get.defaultDialog(
                                            //   title: 'Oops!',
                                            //   titleStyle: GoogleFonts.patuaOne(
                                            //   fontWeight: FontWeight.w600,
                                            //   color: Colors.deepPurple,
                                            //   fontSize: 25,
                                            //   ),
                                            //   middleText:
                                            //   'Please check your internet and try again.',
                                            //   onConfirm: () async {
                                            //     KeyChainManager _keyChainManager =
                                            //     KeyChainManager.getInstance();
                                            //     var _atSignsList = await _keyChainManager
                                            //         .getAtSignListFromKeychain();
                                            //     _atSignsList?.forEach((element) {
                                            //       _keyChainManager
                                            //           .deleteAtSignFromKeychain(element);
                                            //     });
                                            //     c.isLoading.value = false;
                                            //     await Get.to(() => OnbordingScreen());
                                            //   });
                                            // }
                                          //   return atStatus;
                                          // }
                                          // await getAtStatus(atsign);
                                          // var notifiService = clientSdkService.atClientManager.notificationService;
                                          // notifiService.;
                                          // var notificationService = NotificationServiceImpl._(clientSdkService.atClientManager.atClient,
                                          //     atClientManager: clientSdkService.atClientManager);
                                          // final notificationService1 = new NotificationServiceImpl._(clientSdkService.atClientManager, clientSdkService.atClientManager.atClient);
                                          // notificationService.getMonitorStatus();
                                          // await NotificationServiceImpl.getMonitorStatus();


                                          ContactService _contactService = ContactService();
                                          await _contactService.initContactsService('root.atsign.org', 64);
                                          if(_contactService.loggedInUserDetails!.tags != null) {
                                            mydetails = _contactService.loggedInUserDetails!.tags!.cast<dynamic, dynamic>();
                                            print(mydetails);
                                            if (mydetails["image"] == null) {
                                              myImage = initialimage(atsign: atsign);
                                            } else {
                                              myImage = initialimage(
                                                  image: Uint8List.fromList(mydetails['image'].cast<int>()),
                                                  atsign: atsign);
                                            }
                                            if (mydetails["name"] == null) {
                                              myName = atsign.toString();
                                              // loadingDetails = false;
                                            } else {
                                              myName = mydetails["name"];
                                              // loadingDetails = false;
                                            }
                                          }else{
                                            myImage = initialimage(atsign: atsign);
                                            myName = atsign.toString();
                                          }
                                          var notificationService = clientSdkService.atClientManager.notificationService as NotificationServiceImpl;
                                          var monitorStatus = notificationService.getMonitorStatus();
                                          print(monitorStatus);
                                          if(monitorStatus.toString() == "MonitorStatus.started"){
                                          Timer.periodic(Duration(seconds: 1), (timer) async {
                                            // do something or call a function
                                              if(myName != "") {
                                                timer.cancel();
                                                // c.isLoading.value = false;
                                                await Get.to(() =>
                                                    HomeScreen(myImage: myImage,
                                                      myName: myName,myAtSign: atsign.toString()));
                                              };});
                                          }else{
                                                await Get.defaultDialog(
                                                  title: 'Oops!',
                                                  titleStyle: GoogleFonts.patuaOne(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepPurple,
                                                  fontSize: 25,
                                                  ),
                                                  middleText:
                                                  'Please try log in again.',
                                                  onConfirm: () async {
                                                    KeyChainManager _keyChainManager =
                                                    KeyChainManager.getInstance();
                                                    var _atSignsList = await _keyChainManager
                                                        .getAtSignListFromKeychain();
                                                    _atSignsList?.forEach((element) {
                                                      _keyChainManager
                                                          .deleteAtSignFromKeychain(element);
                                                    });
                                                    c.isLoading.value = false;
                                                    await Get.to(() => OnbordingScreen());
                                                  });
                                          };
                                          },

                                        onError: (Object? error) async{
                                          _logger.severe(
                                              'Onboarding throws $error error');
                                          // showLoaderDialog(context);
                                          // KeyChainManager _keyChainManager =
                                          // KeyChainManager.getInstance();
                                          // var _atSignsList =
                                          //     await _keyChainManager
                                          //     .getAtSignListFromKeychain();
                                          // _atSignsList?.forEach((element) {
                                          //   _keyChainManager
                                          //       .deleteAtSignFromKeychain(element);
                                          // });
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(
                                                'Please check your internet and try again later.',
                                                textAlign: TextAlign.center,
                                              )));
                                        },
                                        // nextScreen: (HomeScreen(myImage: myImage,myName: myName,)),
                                        appAPIKey: MixedConstants.apiKey,
                                        rootEnvironment:
                                        RootEnvironment.Production);
                                  },

                                  child: Text(
                                    "Let's start!",
                                    style: TextStyle(
                                        color: color1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  minWidth: double.infinity,
                                  height: 40.toHeight,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  color: color3,
                                ),
                                SizedBox(height: 10.toHeight,),
                                MaterialButton(
                                  onPressed:() async {
                                      KeyChainManager _keyChainManager =
                                      KeyChainManager.getInstance();
                                      var _atSignsList =
                                      await _keyChainManager
                                          .getAtSignListFromKeychain();
                                      _atSignsList?.forEach((element) {
                                        _keyChainManager
                                            .deleteAtSignFromKeychain(element);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                            'You have been logged out',
                                            textAlign: TextAlign.center,
                                          )));

                                  },

                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(
                                        color: color1,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  minWidth: double.infinity,
                                  height: 40.toHeight,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  color: color3,
                                ),
                              ],
                            )

                          ),
                          SizedBox(
                            height: 50.toHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              )],
          ),
        ),
      ),
    );
  }
}

class Controller1 extends GetxController {
  RxBool isLoading = false.obs;
}
