import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spacesignal/app/modules/home/controllers/home_controller.dart';

class ShareByMeSignal extends GetView<HomeController> {
  const ShareByMeSignal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Obx(() {
            return ListView.builder(
                itemCount: controller.signalByMelist.length,
                itemBuilder: (context, index) {
                  var _item = controller.signalByMelist[index];
                  String key = _item['unisignal'];
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.messenger_sharp),
                      onPressed: () {},
                    ),
                    title: Text("${_item['Message']}"),
                    // subtitle: Text("${controller.passlist[index]['login']}"),
                    onTap: () {},
                  );
                });
          }))
        ],
      ),
    );
  }
}
