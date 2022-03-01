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

  var serverError = false.obs;
  var isLoading = true.obs;
  var isReply = false.obs;
  var gotMessage = false.obs;
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
      ..ttl = 604800000
      ..ccd = true; // 1 week to live

    AtKey atKey = AtKey()
      ..key = unikey
      ..metadata = metadata;

    String encodedValue = jsonEncode(data);
    print(encodedValue);
    bool result = await clientSdkService.put(atKey, encodedValue);
    print(result);
    if (result == true) {
      await notifysharesignal(atKey, atKey.key);
      clearSignalEditingController();
      signalByMelist.clear();

      //TODO: readsignal shouldnt  be call here cuz after delivering  the notif it should be read so that user can perform operation on to them
      await readSharedByMeSignal();
    }
  }

//  Notifying the signal to spacesignal
  Future<void> notifysharesignal(AtKey key, String? value) async {
    print("Notification key "+ key.toString());
    print("Notification value " + value!);
    var notifiService = clientSdkService.atClientManager.notificationService;
    key.sharedWith = "@tallcaterpillar";
    Metadata _metadata = Metadata()..ttr = -1
      ..ttl = 604800000
      ..ccd = true; //cached
    key.metadata = _metadata;
    await notifiService.notify(NotificationParams.forUpdate(key, value: value),
        onSuccess: _onSuccessCallback,
        //TODO: Try to resent
        onError: _onErrorCallback);
  }

  //notify sender
  Future<void> notifysender(AtKey key, String? value) async {
    print("Notification value " + value!);
    var notifiService = clientSdkService.atClientManager.notificationService;
    // key.sharedWith = "@tallcaterpillar";
    Metadata _metadata = Metadata()
                                    ..ttr = -1
                                    ..ttl = 2629800000
                                    ..ccd = true;
    key.metadata = _metadata;
    await notifiService.notify(NotificationParams.forUpdate(key, value: value),
        onSuccess: _onSuccessCallback1,
        //TODO: Try to resent
        onError: _onErrorCallback1);
  }
  //shared  signal by me
//specify sharedby with the current  atsign

  Future<void> wantsSignal() async{
    // searchedMessage.value = '';
    // searchedMessageAtsign.value = '';
    // A get variable initialized to null everytime this fuction calls
    // searchedMessage?.value = '';
    var uuid = const Uuid();
    String wkey = 'wantedspacechat' + uuid.v1();
    String val = 'is nothing' + uuid.v1();

    AtKey keyword = AtKey()..key = wkey;

    // try{
     await notifysharesignal(keyword, val);
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
      print(atKey.toString());
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
      await readSharedByMeSignal();
      await notifydeletesignal(unikey);
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

        if(isLoading.value == true && isReply.value == false && gotMessage.value == false) {
          gotMessage.value = true;
          var keyCut =
              notification.key.substring(notification.key.indexOf('headless'));
          print(keyCut);
          String sCut = keyCut.substring(0, keyCut.indexOf('*'));
          String atSigns = keyCut.split('*').last;
          sCut = sCut.replaceAll('headless', '');
          String notification_atsign =
              atSigns.replaceAll('.spacesignal@tallcaterpillar', "");
          print('FROM atSIGN ------------- $notification_atsign');
          print(sCut);
          if(notification_atsign.substring(0,1) != "@"){
            notification_atsign = "@" + notification_atsign;
          }
          //TODO: retrive notification_atsign from the received notification string
          Metadata data = Metadata()..isPublic = true;
          AtKey _atKey = AtKey()
            ..key = sCut
            ..sharedBy = notification_atsign
            ..metadata = data;
          print(_atKey);
          var value = await clientSdkService.get(_atKey).catchError((e) {
            serverError(true);
            isLoading(false);
            print(e.toString());
            print(serverError);
            print(isLoading);
          });
          // print(value);
          // we will receive a map so have to do a json decode
          // we need the message only and the notification_atsign nothing else
          if (value != null) {
            Map<String, dynamic> _decoded = jsonDecode(value);
            print('$_decoded');
            String v = _decoded['Message'];
            print("Receive Signal: $v");
            //assign chatwith atsign also
            if (v != "") {
                serverError(false);
                searchedMessage.value = v;
                searchedMessageAtsign.value = notification_atsign;
                isLoading(false);
                // print(searchedMessage);
                print("Wanna Reply To $notification_atsign On Signal: $v ?");
                // print(isLoading.value);
                // print(isReply.value);
                // print(gotMessage.value);
            }else{
              // serverError(true);
              serverError(true);
              isLoading(false);
              // gotMessage(false);
            }
          }else{
            print("atvalue is null");
            serverError(true);
            isLoading(false);
          }
          // else{
          //   gotMessage(false);
          // }
        // }
          }else{
          print("not gonna process");
          // print(isLoading.value);
          // print(isReply.value);
          // print(gotMessage.value);
        }
          });
    } catch (e) {
      serverError(true);
      isLoading(false);
      print(e.toString());
      print(serverError);
      print(isLoading);
    }
  }

  Future<void> notifydeletesignal(String key) async {
    NotificationService notificationService =
        AtService.getInstance().atClientManager.notificationService;

    Metadata _metadata = Metadata()..ttr = -1;

    AtKey atKey = AtKey()
      ..key = key
      ..sharedWith = "@tallcaterpillar"
      ..metadata = _metadata;//(Metadata()..isCached=true);
    await notificationService.notify(
      NotificationParams.forDelete(atKey),
    );
  }

  void onerror(notificationResult) {
    print(notificationResult);

    logger.d('Error message');
  }

  void _onSuccessCallback(notificationResult) {
    print('Success message');
  }
  void _onSuccessCallback1(notificationResult) {
    print('success to notify the sender ');
    print(notificationResult.toString());
  }
  void _onErrorCallback(notificationResult) {
    print(notificationResult);

// do something on notification error
  }
  void _onErrorCallback1(notificationResult) {
    print("faild to notify the sender ");
    print(notificationResult.toString());
  }
  void onsuccess(notificationResult) {
    // TODO: call readSignal();
    logger.d('Success message');
    print(notificationResult);
    readSharedByMeSignal();
  }
}
