import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';

final defaultTextStyle = TextStyle(fontSize: 25,);





Widget heightGapSizedBox(context) {
  final mqheight = MediaQuery.of(context).size.height;
  return SizedBox(
    height: mqheight * 0.02,
  );
}

Widget heightGapSizedBoxHeading(context) {
  final mqheight = MediaQuery.of(context).size.height;
  return SizedBox(
    height: mqheight * 0.05,
  );
}


Widget moreOptionHead(context, String screenHead) {
  final mqheight = MediaQuery.of(context).size.height;
  final mqwidth = MediaQuery.of(context).size.width;
  return SizedBox(
    height: mqheight * 0.05,
    child: Padding(
      padding: EdgeInsets.fromLTRB(mqwidth * 0.02, 0, 0, 0),
      child: Text(
        screenHead,
        style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800,color: CustomColors.white),
      ),
    ),
  );
}

Widget moreoptionParaText(context, String paratext) {
  final mqwidth = MediaQuery.of(context).size.width;

  return SizedBox(
    child: Padding(
      padding: EdgeInsets.fromLTRB(mqwidth * 0.03, 0, mqwidth * 0.03, 0),
      child: ReadMoreText(
        paratext,
        style: TextStyle(fontStyle: FontStyle.italic,color: CustomColors.white ),
        textAlign: TextAlign.left,
        trimMode: TrimMode.Line,
        trimLines: 60,
      ),
    ),
  );
}



Widget moreOptinParaHead(BuildContext context, String paraHead) {
  final mqwidth = MediaQuery.of(context).size.width;
  final textWidth = mqwidth - (mqwidth * 0.0); // Adjust padding and margin as needed

  return Row(
    children: [
      Container(
        width: textWidth,
        child: Padding(
          padding: EdgeInsets.fromLTRB(mqwidth * 0.03, 0, mqwidth * 0.03, 0),
          child: Text(
            paraHead,
            style: TextStyle(fontSize: 15,color: CustomColors.white), // Adjust the fontSize as needed
          ),
        ),
      ),
    ],
  );
}
