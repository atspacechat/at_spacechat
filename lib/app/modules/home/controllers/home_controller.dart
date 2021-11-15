import 'dart:convert';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:at_client/src/service/notification_service.dart';
import 'package:at_client/src/service/notification_service_impl.dart';

class HomeController extends GetxController {
  TextEditingController? signalEditingController;
  AtService clientSdkService = AtService.getInstance();
  var _atClientManager =
      AtService.getInstance().atClientManager.notificationService;

  var logger = Logger(
    printer: PrettyPrinter(),
  );
  var atClient = AtService.getInstance().getAtClientForAtsign();
  var signallist = List<Map<String, dynamic>>.empty(growable: true).obs;
  var signalByMelist = List<Map<String, dynamic>>.empty(growable: true).obs;
  var atClientPreference;
  String? currentAtsign;
  String middlemanAtsign = "flamencoemotional";
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

  Future<dynamic> readSignalValue(AtKey atKey) async {
    // ignore: unnecessary_null_comparison
    if (atKey != null) {
      return await clientSdkService.get(atKey);
    }
    return '';
  }

  Future<void> readSignal() async {
    List<AtKey> pSignal;
    //because we want the signal that are public from the middlemannAtsign 

    pSignal = await clientSdkService.getAtKeys(sharedBy: middlemanAtsign);
    print(pSignal);
    for (AtKey atKey in pSignal) {
      var value = await clientSdkService.get(atKey);
      Map<String, dynamic> _decoded = jsonDecode(value);
      signallist.add(_decoded);
      logger.d('Reading Signanl' + _decoded['Message']);
    }

    // response.retainWhere((element) => !element.metadata!.isCached);
  }

  Future<void> shareSignal(Map data) async {
    AtKey atKey = AtKey();
    atKey.key = data['unisignal'];
    // var metadata = Metadata()..isPublic = true;
    // ..ccd = true
    
    atKey.sharedWith = middlemanAtsign;
    // atKey.metadata = metadata;
    print(atKey);
    String encodedValue = jsonEncode(data);
    print(encodedValue);

    bool result = await clientSdkService.put(atKey, encodedValue);
    print(result);
    if (result == true) {
     await notifysharesignal(atKey, encodedValue);
      clearSignalEditingController();
      signallist.clear();
      signalByMelist.clear();
      //TODO: readsignal shouldnt  be call here cuz after delivering  the notif it should be read so that user can perform operation on to them
      readSignal();
      readSharedByMeSignal();
    }
  }

//  Notifying the signal to spacesignal
  Future<void> notifysharesignal(var key, String value) async {
    var atClient = clientSdkService.atClientManager;
    var notificationService = atClient.notificationService;
    atClient.syncService;
    var result =  notificationService.notify(
        NotificationParams.forUpdate(key, value: value),
        onSuccess: _onSuccessCallback,
        //TODO: Try to resent
        onError: _onErrorCallback);
      print('notify result $result');
  }

  //shared  signal by me
//specify sharedby with the current  atsign

  Future<void> readSharedByMeSignal() async {
    /// need to be defined clientSdkService.atsign
    String? atSign = clientSdkService.currentAtsign;
    List<AtKey> response;
    response = await clientSdkService.getAtKeys(sharedBy: currentAtsign);
    response.retainWhere((element) => !element.metadata!.isCached);
    for (AtKey atKey in response) {
      var value = await readSignalValue(atKey);
      Map<String, dynamic> _decoded = jsonDecode(value);

      signalByMelist.add(_decoded);

      logger.d('Reading Shared by me Signanl' + _decoded['Message']);
    }
  }

  Future<void> recallSignal(String unikey) async {
    var metaData = Metadata()
      ..ccd = true
      ..isPublic = true;
    var key = AtKey()
      ..key = '$unikey'
      ..metadata = metaData;

    var result = await clientSdkService.delete(key);
    if (result == true) {
      signallist.clear();
      signalByMelist.clear();
    } else {
      print("Error Deleting");
    }
  }

  Future<void> notifydeletesignal(AtKey key) async {
    NotificationService notificationService =
        AtService.getInstance().atClientManager.notificationService;
    notificationService.notify(
      NotificationParams.forDelete(key),
    );
  }

  onerror(notificationResult) {
    print(notificationResult);

    logger.d('Error message');
  }

  void _onSuccessCallback(notificationResult) {
    print('Success message');
    print('Success message' + notificationResult);
  }

  void _onErrorCallback(notificationResult) {
    print(notificationResult);

// do something on notification error
  }

  onsuccess(notificationResult) {
    // TODO: call readSignal();
    logger.d('Success message');
    print(notificationResult);
    

    readSignal();
    readSharedByMeSignal();
  }
}
