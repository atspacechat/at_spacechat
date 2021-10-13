import 'package:flutter/material.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:spacesignal/app/modules/home/views/home_screen.dart';
import 'package:spacesignal/utils/constants.dart';
import 'package:at_common_flutter/services/size_config.dart';

import '../../../../sdk_service.dart';
import 'homeview.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({Key? key}) : super(key: key);

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
  @override
  void initState() {
    AtService.getInstance()
        .getAtClientPreference()
        .then((AtClientPreference value) => atClientPrefernce = value);
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
            children: <Widget>[
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
              Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.0.toWidth,
                    vertical: 55.0.toHeight,
                  ),
                  child: Column(
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
                                image: AssetImage('assets/images/logo.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 110.toHeight,
                          ),
                          Container(
                            //width: double.infinity,
                            height: 60.toHeight,
                            padding: EdgeInsets.symmetric(
                              vertical: 5.toHeight,
                              horizontal: 10.toWidth,
                            ),

                            child: MaterialButton(
                              onPressed: () async {
                                Onboarding(
                                    domain: MixedConstants.rootDomain,
                                    context: context,
                                    atClientPreference: atClientPrefernce,
                                    appColor:
                                        const Color.fromARGB(255, 240, 94, 62),
                                    onboard:
                                        (Map<String?, AtClientService> value,
                                            String? atsign) {
                                      AtService.getInstance()
                                          .atClientServiceMap = value;
                                      _logger.finer(
                                          'Successfully onboarded $atsign');
                                    },
                                    onError: (Object? error) {
                                      _logger.severe(
                                          'Onboarding throws $error error');
                                    },
                                    nextScreen: HomeScreen(),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              color: color3,
                            ),
                          ),
                          SizedBox(
                            height: 50.toHeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
