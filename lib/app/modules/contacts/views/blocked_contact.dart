/// Screen exposed to see blocked contacts and unblock them

// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/widgets/custom_app_bar.dart';
import 'package:spacesignal/utils/colors.dart';
import 'package:spacesignal/utils/text_strings.dart';
import 'package:spacesignal/app/modules/contacts/views/blocked_user_card.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_common_flutter/services/size_config.dart';
import 'package:spacesignal/app/modules/contacts/controllers/contact_service.dart';

class BlockedScreen extends StatefulWidget {
  @override
  _BlockedScreenState createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  ContactService? _contactService;
  @override
  void initState() {
    _contactService = ContactService();
    _contactService!.fetchBlockContactList();
    super.initState();
  }

  bool isBlocking = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: ColorConstants.scaffoldColor,
      appBar: CustomAppBar(
        showBackButton: true,
        showTitle: true,
        showLeadingIcon: true,
        titleText: TextStrings().blockedContacts,
      ),
      body: RefreshIndicator(
        color: Colors.transparent,
        strokeWidth: 0,
        backgroundColor: Colors.transparent,
        onRefresh: () async {
          await _contactService!.fetchBlockContactList();
        },
        child: Container(
          color: ColorConstants.appBarColor,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  initialData: _contactService!.blockContactList,
                  stream: _contactService!.blockedContactStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.data.isEmpty
                        ? Center(
                      child: Text(
                        TextStrings().emptyBlockedList,
                        style: TextStyle(
                          fontSize: 16.toFont,
                          color: ColorConstants.greyText,
                        ),
                      ),
                    )
                        : ListView.separated(
                      padding:
                      EdgeInsets.symmetric(vertical: 40.toHeight),
                      itemCount: _contactService!.blockContactList.length,
                      separatorBuilder: (context, index) => Divider(
                        indent: 16.toWidth,
                      ),
                      itemBuilder: (context, index) {
                        return BlockedUserCard(
                          blockeduser: snapshot.data[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
