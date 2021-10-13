// ignore_for_file: unnecessary_const
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spacesignal/app/modules/home/controllers/home_controller.dart';
import 'package:spacesignal/app/modules/home/views/signal_by_me.dart';
import 'package:spacesignal/app/modules/home/views/uni_signal.dart';
import 'package:spacesignal/utils/constants.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Homeview extends GetView<HomeController> {
  late String title;

  Homeview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      body: const Center(),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.chat),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
              child: const Icon(Icons.send_sharp),
              foregroundColor: Colors.deepPurple,
              backgroundColor: Colors.white,
              label: 'Universal Singal',
              onPressed: () {
                Get.defaultDialog(
                  barrierDismissible: false,
                  titlePadding: const EdgeInsets.only(
                    top: 20,
                    bottom: 0,
                  ),
                  title: "Send a signal",
                  titleStyle: GoogleFonts.patuaOne(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                    fontSize: 25,
                  ),
                  content: Container(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 0,
                        right: 20.0,
                        bottom: 0,
                      ),
                      height: 150,
                      width: 400,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Write your message...',
                          hintStyle: TextStyle(
                            color: Colors.deepPurple.withOpacity(0.4),
                            fontSize: 15,
                          ),
                        ),
                        controller: controller.signalEditingController,
                      )),
                  actions: <Widget>[
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.deepPurple)),
                        elevation: 5.0,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurple,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Colors.deepPurple)),
                        elevation: 5.0,
                        color: Colors.deepPurple,
                        onPressed: () {
                          sharesignal(controller.signalEditingController!.text);
                        },
                        child: Text(
                          "Send",
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ))
                  ],
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.list_alt),
              foregroundColor: Colors.deepPurple,
              backgroundColor: Colors.white,
              label: 'Alive Signals',
              onPressed: () {
                Get.to(UniSignal());
              }),
          SpeedDialChild(
              child: const Icon(Icons.list_alt),
              foregroundColor: Colors.deepPurple,
              backgroundColor: Colors.white,
              label: 'Send by me',
              onPressed: () {
                Get.to(ShareByMeSignal());
              }),
        ],
        closedForegroundColor: Colors.deepPurpleAccent,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.white,
        openBackgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  void sharesignal(String msg) {
    var uuid = const Uuid();

    String unikey = MixedConstants.regex + uuid.v1().replaceAll('-', '_');

    controller.shareSignal({'Message': msg, 'unisignal': unikey});
  }
}
