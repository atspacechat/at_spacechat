import 'dart:io';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart' as at_commons;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:spacesignal/utils/constants.dart';
import 'package:at_commons/at_commons.dart';

class AtService {
  static final AtService _singleton = AtService._internal();

  AtService._internal();
  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();

  factory AtService.getInstance() {
    return _singleton;
  }
  String? atsign;

  Future<AtClientPreference> getAtClientPreference() async {
    Directory appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    AtClientPreference _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..namespace = MixedConstants.appNamespace
      ..rootDomain = MixedConstants.rootDomain
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  Map<String?, AtClientService> atClientServiceMap =
      <String, AtClientService>{};

   AtClient _getAtClientForAtsign() {
    return AtClientManager.getInstance().atClient;
  }


  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return _keyChainManager.getAtSign();
  }

  Future<bool> put(AtKey atKey, String value) async {
    return await _getAtClientForAtsign()
        .put(atKey, value);
  }


  Future<bool> delete({String? key}) async {
    at_commons.AtKey atKey = at_commons.AtKey()..key = key;
    return _getAtClientForAtsign().delete(atKey);
  }

  Future<String> get(AtKey atKey) async {
    var result = await _getAtClientForAtsign().get(atKey);
    return result.value;
  }

  Future<List<AtKey>> getAtKeys({String? sharedBy}) async {
    return await _getAtClientForAtsign()
        .getAtKeys(sharedBy:sharedBy,regex: MixedConstants.regex);
  }

  Future<bool> makeAtsignPrimary(String atsign) async {
    atsign = formatAtSign(atsign)!;
    return _keyChainManager.makeAtSignPrimary(atsign);
  }

  ///Returns null if [atsign] is null else the formatted [atsign].
  ///[atsign] must be non-null.
  String? formatAtSign(String? atsign) {
    if (atsign == null) {
      return null;
    }
    atsign = atsign.trim().toLowerCase().replaceAll(' ', '');
    atsign = !atsign.startsWith('@') ? '@' + atsign : atsign;
    return atsign;
  }
}
