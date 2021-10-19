import 'dart:io';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart' as at_commons;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:spacesignal/utils/constants.dart';
import 'package:at_commons/at_commons.dart';

class AtService {
  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  static final AtService _singleton = AtService._internal();
  AtService._internal();
  factory AtService.getInstance() {
    return _singleton;
  }
  String? currentAtsign;

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

  Future<bool> makeAtSignPrimary(String atsign) async {
    AtClientManager.getInstance().setCurrentAtSign(atsign, MixedConstants.appNamespace, AtClientPreference());
    currentAtsign = atsign;
    return await _keyChainManager.makeAtSignPrimary(atsign);
  }
  // AtClient? _getAtClientForAtsign({String? atsign}) {
  //   atsign ??= atsign;
  //   if (atClientServiceMap.containsKey(atsign)) {
  //     return AtClientManager.getInstance().atClient;
  //   }
  //   return null;
  // }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await _keyChainManager.getAtSign();
  }

  Future<bool> put(AtKey atKey, String value) async {
    return _getAtClientForAtsign().put(atKey, value);
  }

  Future<bool> delete(at_commons.AtKey atKey) async {
    return await  _getAtClientForAtsign().delete(atKey);
  }

  Future<String> get(AtKey atKey) async {
    var result = await _getAtClientForAtsign().get(atKey);
    return result.value;
  }

  Future<List<AtKey>> getAtKeys({String? sharedBy}) async {
    return await _getAtClientForAtsign().getAtKeys(regex: MixedConstants.regex);
  }

  Future<bool> makeAtsignPrimary(String atsign) async {
    atsign = formatAtSign(atsign)!;
    return _keyChainManager.makeAtSignPrimary(atsign);
  }

  Future<void> deleteAtsign(String atsign) async {
    return await KeychainUtil.deleteAtSignFromKeychain(atsign);
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
