import 'dart:convert';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:spacesignal/sdk_service.dart';
import 'package:at_client/src/service/notification_service.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  TextEditingController? signalEditingController;
  AtService clientSdkService = AtService.getInstance();
  var _notificationService =
      AtService.getInstance().atClientManager.notificationService;

  var logger = Logger(
    printer: PrettyPrinter(),
  );
  var searchedMessage = "".obs;
  var searchedMessageAtsign = "".obs;

  var serverError = true.obs;
  var isLoading = true.obs;
  var atClient = AtService.getInstance().getAtClientForAtsign();
  var signalByMelist = List<Map<String, dynamic>>.empty(growable: true).obs;
  var atClientPreference;
  String? currentAtsign;
  String middlemanAtsign = "tallcaterpillar";
  @override
  void onInit() {
    super.onInit();
    readSharedByMeSignal();
    signalEditingController = TextEditingController();
    monitorForSignals();
  }

  void clearSignalEditingController() {
    signalEditingController!.clear();
  }

  Future<dynamic> readSignalValue(AtKey atKey) async {
    // ignore: unnecessary_null_comparison
    if (atKey != null) {
      var metaData = Metadata()..isPublic = true;
      atKey.metadata = metaData;
      atKey.sharedBy = middlemanAtsign;
      return await clientSdkService.get(atKey);
    }
    return '';
  }

  Future<dynamic> readSignalValue2(AtKey atKey) async {
    // ignore: unnecessary_null_comparison
    if (atKey != null) {
      return await clientSdkService.get(atKey);
    }
    return '';
  }

  Future<void> shareSignal(Map data) async {
    String unikey = await data['unisignal'];
    var metadata = Metadata()
      ..isPublic = true
      ..ttl = 604800000; // 1 week to live

    AtKey atKey = AtKey()
      ..key = unikey
      ..metadata = metadata;

    String encodedValue = jsonEncode(data);
    print(encodedValue);
    bool result = await clientSdkService.put(atKey, encodedValue);
    print(result);
    if (result == true) {
      notifysharesignal(atKey, atKey.key);
      clearSignalEditingController();
      signalByMelist.clear();

      //TODO: readsignal shouldnt  be call here cuz after delivering  the notif it should be read so that user can perform operation on to them
      readSharedByMeSignal();
    }
  }

//  Notifying the signal to spacesignal
  Future<void> notifysharesignal(AtKey key, String? value) async {
    print("Notification value" + value!);
    var notifiService = clientSdkService.atClientManager.notificationService;
    key.sharedWith = "@tallcaterpillar";
    Metadata _metadata = Metadata()..ttr = -1;

    key.metadata = _metadata;
    notifiService.notify(NotificationParams.forUpdate(key, value: value),
        onSuccess: _onSuccessCallback,
        //TODO: Try to resent
        onError: _onErrorCallback);
  }

  //notify sender
  Future<void> notifysender(AtKey key, String? value) async {
    print("Notification value" + value!);
    var notifiService = clientSdkService.atClientManager.notificationService;
    // key.sharedWith = "@tallcaterpillar";
    // Metadata _metadata = Metadata()..ttr = -1;
    //
    // key.metadata = _metadata;
    notifiService.notify(NotificationParams.forUpdate(key, value: value),
        onSuccess: _onSuccessCallback1,
        //TODO: Try to resent
        onError: _onErrorCallback1);
  }
  //shared  signal by me
//specify sharedby with the current  atsign

  void wantsSignal() {
    searchedMessage.value = '';
    searchedMessageAtsign.value = '';
    // A get variable initialized to null everytime this fuction calls
    // searchedMessage?.value = '';
    var uuid = const Uuid();
    String wkey = 'wantedspacechat' + uuid.v1();
    String val = 'is nothing' + uuid.v1();

    AtKey keyword = AtKey()..key = wkey;

    // try{
      notifysharesignal(keyword, val);
    // }catch (e) {
    //   serverError(true);
    //   isLoading(false);
    // };
  }

  Future<void> readSharedByMeSignal() async {
    /// need to be defined clientSdkService.atsign
    String? atSign = clientSdkService.currentAtsign;
    List<AtKey> response;
    response = await clientSdkService.getAtKeys2(sharedBy: currentAtsign);
    response.retainWhere((element) => !element.metadata!.isCached);
    for (AtKey atKey in response) {
      var value = await readSignalValue2(atKey);
      Map<String, dynamic> _decoded = jsonDecode(value);
      signalByMelist.add(_decoded);
      logger
          .d('Reading Shared by me Signanl          :::' + _decoded['Message']);
    }
  }

  Future<void> recallSignal(String unikey) async {
    var metaData = Metadata()..isPublic = true;
    var key = AtKey()
      ..key = '$unikey'
      ..metadata = metaData;

    var result = await clientSdkService.delete(key);
    if (result == true) {
      print(result);
      signalByMelist.clear();
      readSharedByMeSignal();
      notifydeletesignal(unikey);
    } else {
      print("Error Deleting");
    }
  }

  void monitorForSignals() {
    try {
      _notificationService
          .subscribe(regex: 'headless')
          .listen((notification) async {
        print(notification);

        var keyCut =
            notification.key.substring(notification.key.indexOf('headless'));

        String sCut = keyCut.substring(0, keyCut.indexOf('*'));

        String atSigns = keyCut.split('*').last;
        sCut = sCut.replaceAll('headless', '');
        String notification_atsign =
            atSigns.replaceAll('.spacesignal@tallcaterpillar', "");
        print('FROM atSIGN ------------- $notification_atsign');
        print(sCut);
        //TODO: retrive notification_atsign from the received notification string
        Metadata data = Metadata()..isPublic = true;
        AtKey _atKey = AtKey()
          ..key = sCut
          ..sharedBy = notification_atsign
          ..metadata = data;
        var value = await clientSdkService.get(_atKey);
        // we will receive a map so have to do a json decode
        // we need the message only and the notification_atsign nothing else
        if (value != null) {
          Map<String, dynamic> _decoded = jsonDecode(value);
          print('$_decoded');
          String v = _decoded['Message'];
          print("Receive Signal: $v");
          //assign chatwith atsign also
          if (v.isNotEmpty && isLoading.value) {
            serverError(false);
            searchedMessage.value = v;
            searchedMessageAtsign.value = notification_atsign;
            isLoading(false);
            // print(searchedMessage);
            print("Monitor Signal: $v");
          }
        }
      });
    } catch (e, stackTrace) {
      print(e.toString());
    }
  }

  Future<void> notifydeletesignal(String key) async {
    NotificationService notificationService =
        AtService.getInstance().atClientManager.notificationService;
    Metadata _metadata = Metadata()..ttr = -1;
    AtKey atKey = AtKey()
      ..key = key
      ..sharedWith = "@tallcaterpillar"
      ..metadata = _metadata;
    notificationService.notify(
      NotificationParams.forDelete(atKey),
    );
  }

  onerror(notificationResult) {
    print(notificationResult);

    logger.d('Error message');
  }

  void _onSuccessCallback(notificationResult) {
    print('Success message');
  }
  void _onSuccessCallback1(notificationResult) {
    print('success to notify the sender '+ notificationResult.toString());
  }
  void _onErrorCallback(notificationResult) {
    print(notificationResult);

// do something on notification error
  }
  void _onErrorCallback1(notificationResult) {
    print("faild to notify the sender "+notificationResult.toString());
  }
  onsuccess(notificationResult) {
    // TODO: call readSignal();
    logger.d('Success message');
    print(notificationResult);

    readSharedByMeSignal();
  }
}
