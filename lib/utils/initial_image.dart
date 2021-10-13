import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';

// ignore: must_be_immutable
class initialimage extends StatelessWidget {
  double? size;
  String? atsign;
  Color? backgroundColor;
  initialimage(
      {Key? key,
        this.size,
        this.atsign,
        this.backgroundColor})
      : super(key: key);

  RegExp _isLetterRegExp = RegExp(r'[a-z]', caseSensitive: false);
  bool isLetter(String letter) => _isLetterRegExp.hasMatch(letter);

  @override

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (isLetter(atsign![1])){
      backgroundColor= color['${atsign![1].toUpperCase()}'];
    }else{
      backgroundColor=Color(0xFFF05E3E);
    }
    return Container(
      height: 40.toFont,
      width: 40.toFont,
      decoration: BoxDecoration(
        color: backgroundColor,
          shape: BoxShape.circle,
        //borderRadius: BorderRadius.circular(size.toWidth),
      ),
      child: Center(
        child: ClipOval(
          child:Text(
          atsign.toString().substring(1).toUpperCase(),
          overflow: TextOverflow.fade,
          softWrap: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.toFont,
            fontWeight: FontWeight.w700,
          )),
        ),
      ),
    );
  }
  final color = {
    'A': Color(0xFFAA0DFE),
    'B': Color(0xFF3283FE),
    'C': Color(0xFF85660D),
    'D': Color(0xFF782AB6),
    'E': Color(0xFF565656),
    'F': Color(0xFF1C8356),
    'G': Color(0xFF16FF32),
    'H': Color(0xFFF7E1A0),
    'I': Color(0xFFE2E2E2),
    'J': Color(0xFF1CBE4F),
    'K': Color(0xFFC4451C),
    'L': Color(0xFFDEA0FD),
    'M': Color(0xFFFE00FA),
    'N': Color(0xFF325A9B),
    'O': Color(0xFFFEAF16),
    'P': Color(0xFFF8A19F),
    'Q': Color(0xFF90AD1C),
    'R': Color(0xFFF6222E),
    'S': Color(0xFF1CFFCE),
    'T': Color(0xFF2ED9FF),
    'U': Color(0xFFB10DA1),
    'V': Color(0xFFC075A6),
    'W': Color(0xFFFC1CBF),
    'X': Color(0xFFB00068),
    'Y': Color(0xFFFBE426),
    'Z': Color(0xFFFA0087),
  };
}

