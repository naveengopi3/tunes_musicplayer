import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:tunes_musicplayer/common/color_extention.dart';
import 'package:tunes_musicplayer/common/others.dart';
import 'package:tunes_musicplayer/more_option/privacy_policy.dart';
import 'package:tunes_musicplayer/more_option/terms_and_conditons.dart';

class MoreOptionScreen extends StatefulWidget {
  const MoreOptionScreen({super.key});

  @override
  State<MoreOptionScreen> createState() => _MoreOptionScreenState();
}

class _MoreOptionScreenState extends State<MoreOptionScreen> {
  bool notify = true;

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    final mqheight = MediaQuery.of(context).size.height;
    // final mqwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CustomColors.black,
      appBar: AppBar(
        backgroundColor: CustomColors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: CustomColors.white,
            )),
        title: const Text(
          'More Option',
          style: TextStyle(color: CustomColors.white),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: mqheight * 5,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TermsAndConditions()));
                },
                title: const Text(
                  "Terms and Conditions",
                  style: TextStyle(color: CustomColors.white, fontSize: 20),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: CustomColors.white,
                  size: 35,
                ),
              ),
              const Divider(
                color: CustomColors.darkGrey,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PrivacyAndPolicy()));
                },
                title: const Text(
                  "Privacy and Policy",
                  style: TextStyle(color: CustomColors.white, fontSize: 20),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: CustomColors.white,
                  size: 35,
                ),
              ),
              const Divider(
                color: CustomColors.darkGrey,
              ),
              ListTile(
                  onTap: () {},
                  title: const Text(
                    "Notification",
                    style: TextStyle(color: CustomColors.white, fontSize: 20),
                  ),
                  trailing: SwitcherButton(
                    offColor: CustomColors.white,
                    onColor: CustomColors.purpleAccent,
                    value: true,
                    onChange: (value) {
                      audioPlayer.showNotification == notify;
                    },
                  )),
              const Divider(
                color: CustomColors.darkGrey,
              ),
              ListTile(
                onTap: () {
                  aboutPopUp();
                },
                title: const Text(
                  "About",
                  style: TextStyle(color: CustomColors.white, fontSize: 20),
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: CustomColors.white,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  aboutPopUp() {
    showAboutDialog(
        context: context,
        applicationName: 'Tunes',  
        applicationIcon: Image.asset(
          'assets/Logo.png',
          height: 70, 
          width: 60,    
        ),
        applicationVersion: "1.0.0",
        children: [
          const Text(
              "Tunes is an offline music player app which allows use to hear music from their storage and also do functions like add to favorites , create playlists , recently played , mostly played etc."),
          heightGapSizedBox(context),
          const Text('''App developed by :

Naveen G''')
        ]);
  }
}
