import 'dart:convert';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spacesignal/sdk_service.dart';

class HomeController extends GetxController {
  TextEditingController? signalEditingController;
  AtService clientSdkService = AtService.getInstance();
  var signallist = List<Map<String, dynamic>>.empty(growable: true).obs;
  var signalByMelist = List<Map<String, dynamic>>.empty(growable: true).obs;
  var atClientPreference;
  String? currentAtsign;

  @override
  void onInit() {
    super.onInit();
    readSignal();
    readSharedByMeSignal();
    signalEditingController = TextEditingController();
  }

  void clearSignalEditingController() {
    signalEditingController!.clear();
  }

  Future<void> shareSignal(Map data) async {
    AtKey atKey = AtKey();
    atKey.key = data['unisignal'];
    var metadata = Metadata()
      ..isPublic = true
      ..ttr = -1;
    atKey.metadata = metadata;

    String encoded = jsonEncode(data);
    print(encoded);

    bool result = await clientSdkService.put(atKey, encoded);
    if (result == true) {
      clearSignalEditingController();
      signallist.clear();
      signalByMelist.clear();
      readSignal();
      readSharedByMeSignal();
    }
  }

  Future<dynamic> readSignalValue(AtKey atKey) async {
    // ignore: unnecessary_null_comparison
    if (atKey != null) {
      return await clientSdkService.get(atKey);
    }
    return '';
  }

  Future<void> readSignal() async {
    List<AtKey> response;
    response = await clientSdkService.getAtKeys();
    print(response);
    response.retainWhere((element) => !element.metadata!.isCached);
    for (AtKey atKey in response) {
      var value = await readSignalValue(atKey);
      Map<String, dynamic> _decoded = jsonDecode(value);

      signallist.add(_decoded);

      print(_decoded['Message']);
    }
  }

  //shared  signal by me
//specify sharedby with the current  atsign

  Future<void> readSharedByMeSignal() async {
    /// need to be defined clientSdkService.atsign
    String? atSign = clientSdkService.currentAtsign;
    List<AtKey> response;
    response = await clientSdkService.getAtKeys(sharedBy: atSign);
    response.retainWhere((element) => !element.metadata!.isCached);
    for (AtKey atKey in response) {
      var value = await readSignalValue(atKey);
      Map<String, dynamic> _decoded = jsonDecode(value);

      signalByMelist.add(_decoded);

      print(_decoded['Message']);
    }
  }

  Future<void> recallSignal(String unikey) async {
    var metaData = Metadata()
      ..ttr = -1
      ..ccd = true
      ..isPublic = true;
    var key = AtKey()
      ..key = '$unikey'
      ..metadata = metaData;

    var result = await clientSdkService.delete(key);
    if (result == true) {
      signallist.clear();
      signalByMelist.clear();
      readSignal();
      readSharedByMeSignal();
    } else {
      print("Error Deleting");
    }
  }
}
