import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:spacesignal/app/modules/contacts/views/contacts_screen.dart';
import 'package:spacesignal/app/modules/home/controllers/home_controller.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:get/get.dart';
import 'package:spacesignal/utils/constants.dart';
import 'package:spacesignal/utils/initial_image.dart';
import 'package:uuid/uuid.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, required this.text, this.ppress});
  IconData? iconData;
  String text;
  void ppress;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.centerItemText,
    this.height: 75.0,
    this.iconSize: 30.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
    required this.myImage,
    required this.myName,
  }) {
    assert(this.items!.length == 2 || this.items!.length == 4);
  }
  final List<FABBottomAppBarItem>? items;
  final String? centerItemText;
  final double height;
  final double iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int>? onTabSelected;
  final initialimage myImage;
  final String myName;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

String? activeAtSign;

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;
  _updateIndex(int index) {
    widget.onTabSelected!(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index], myImage: widget.myImage,
        //index: index,
        // onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: CircularNotchedRectangle(), //widget.notchedShape,
      notchMargin: 10.0.toHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            SizedBox(height: 10),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({FABBottomAppBarItem? item, required initialimage myImage}) {
    //int index,ValueChanged<int> onPressed
    // Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    final HomeController _controller =
        Get.put<HomeController>(HomeController());

    Future<void> sharesignal(String msg) async {
      // var uuid = const Uuid();
      var uuid = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
      String unikey = MixedConstants.regex + uuid;
      await _controller.shareSignal({'Message': msg, 'unisignal': unikey});
      // Get.back();
      Navigator.pop(context);
    }

    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => {
              if (item!.text == "Chats")
                Get.to(() => ContactScreen(myImage: widget.myImage, myName: widget.myName))
              else{
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
                    content:
                    // Obx(() => Container(
                    //   child: loading_control.loading.value
                    //   ? Container(
                    //         child:Row(children: <Widget>[
                    //           CircularProgressIndicator(),
                    //           Container(
                    //             height: 10.toHeight,
                    //             width: 30.toWidth,
                    //           ),
                    //           Text(
                    //             "Sending ...",
                    //             textAlign: TextAlign.right,
                    //             style: TextStyle(
                    //                 fontSize: 15.toFont,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Color(0xFF584797)),
                    //             maxLines: null,
                    //           )
                    //         ])
                    //     )
                    // :
                      Container(
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
                          controller: _controller.signalEditingController,
                        )),
          // )),
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
                          onPressed: () async {
                            if(_controller.signalEditingController!.text.trim() != ""){
                              // loading_control.loading.value = true;
                              // Get.back();
                              Navigator.pop(context);
                              unawaited(Get.defaultDialog(
                                  barrierDismissible: false,
                                  titlePadding: const EdgeInsets.only(
                                    // top: 20,
                                    bottom: 0,
                                  ),
                                  title: "",
                                  titleStyle: GoogleFonts.patuaOne(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepPurple,
                                    fontSize: 25,
                                  ),
                                  content: Container(
                                      child:Row(children: <Widget>[
                                        Container(
                                          height: 10.toHeight,
                                          width: 30.toWidth,
                                        ),
                                        CircularProgressIndicator(),
                                        Container(
                                          height: 10.toHeight,
                                          width: 30.toWidth,
                                        ),
                                        Text(
                                          "Sending ...",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 15.toFont,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF584797)),
                                          maxLines: null,
                                        )
                                      ]))));
                              await sharesignal(_controller.signalEditingController!.text);
                              // Get.back();
                              Navigator.pop(context);
                              // loading_control.loading.value = false;
                            }
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
                  )
                }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item!.iconData,
                    color: Colors.deepPurple, size: widget.iconSize),
                SizedBox(height: 10),
                Text(
                  item.text,
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController controller = TextEditingController();

  // initialsendsignal(String signal) async {
  //   AtService clientSdkService = AtService.getInstance();
  //   String? currentAtSign = await clientSdkService.getAtSign();
  //   setState(() {
  //     activeAtSign = currentAtSign;
  //   });
  //   // SignalService().initSignalService(clientSdkService.atClientServiceInstance.atClient, activeAtSign,'root.atsign.org',64);
  //   // SignalService().sendSignal(signal);
  //   // SignalService().showSignal();
  // }
}
