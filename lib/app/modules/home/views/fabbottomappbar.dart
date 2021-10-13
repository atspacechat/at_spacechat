import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:spacesignal/app/modules/home/views/homeview.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:get/get.dart';

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
        item: widget.items![index],
        //index: index,
       // onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      shape: CircularNotchedRectangle(),//widget.notchedShape,
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
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({FABBottomAppBarItem? item}) { //int index,ValueChanged<int> onPressed
   // Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => {if(item!.text=="Chats"){_chat()}else{Get.to(Homeview())}},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item!.iconData, color: Colors.deepPurple, size: widget.iconSize),
                Text(item.text, style: TextStyle(color: Colors.deepPurple),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _chat() {
    // Navigator.of(context).push(MaterialPageRoute(
    //     // builder: (BuildContext context) => ContactScreen(),));
  }

  TextEditingController controller = TextEditingController();


  initialsendsignal(String signal) async {
    AtService clientSdkService = AtService.getInstance();
    String? currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      activeAtSign = currentAtSign;
    });
    // SignalService().initSignalService(clientSdkService.atClientServiceInstance.atClient, activeAtSign,'root.atsign.org',64);
    // SignalService().sendSignal(signal);
    // SignalService().showSignal();

  }

}