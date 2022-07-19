import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/PageLoadingProvider.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String currentLanguageCode = 'kr';
  String currentLanguageDirection = 'rtl';

  Map languageLabel = {
    'kr': 'کوردی',
    'en': 'English',
    'ar': 'عربی',
  };

  @override
  void initState() {
    super.initState();
    final language = Provider.of<Language>(context, listen: false);
    currentLanguageCode = language.languageCode;
    currentLanguageDirection = language.languageDirection;
  }

  @override
  Widget build(BuildContext context) {
    final textAppStyle = Provider.of<AppTextStyle>(context, listen: false);
    final language = Provider.of<Language>(context, listen: false);
    final words = language.words;
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            words["change-language"],
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(languageLabel[currentLanguageCode]),
              languageButton(
                title: 'کوردی',
                languageCode: 'kr',
                image: AppIcons.kurdishFlag,
                onTap: () {
                  Provider.of<PageLoadingProvider>(context, listen: false)
                      .changeAllHomeLoading();
                  setState(() {
                    currentLanguageCode = 'kr';
                    currentLanguageDirection = 'rtl';
                  });
                  language.setLanguage(
                      currentLanguageCode, currentLanguageDirection);
                  textAppStyle.setLanguageCode(currentLanguageCode);
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: languageButton(
                  title: 'عربی',
                  languageCode: 'ar',
                  image: AppIcons.arabicFlag,
                  onTap: () {
                    Provider.of<PageLoadingProvider>(context, listen: false)
                        .changeAllHomeLoading();
                    setState(() {
                      currentLanguageCode = 'ar';
                      currentLanguageDirection = 'rtl';
                    });
                    language.setLanguage(
                        currentLanguageCode, currentLanguageDirection);
                    textAppStyle.setLanguageCode(currentLanguageCode);
                    Navigator.pop(context);
                  },
                ),
              ),
              languageButton(
                title: 'English',
                languageCode: 'en',
                image: AppIcons.englishFlag,
                onTap: () {
                  Provider.of<PageLoadingProvider>(context, listen: false)
                      .changeAllHomeLoading();
                  setState(() {
                    currentLanguageCode = 'en';
                    currentLanguageDirection = 'ltr';
                  });
                  language.setLanguage(
                      currentLanguageCode, currentLanguageDirection);
                  textAppStyle.setLanguageCode(currentLanguageCode);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageButton({
    Key key,
    @required String title,
    @required String image,
    @required String languageCode,
    @required Function onTap,
  }) {
    return GestureDetector(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      // title: Text(title, style: AppTextStyle.boldTitle16),
      // tileColor: currentLanguageCode == languageCode
      //     ? PaletteColors.mainAppColor.withOpacity(0.3)
      //     : Colors.white,
      child: Image.asset(
        image,
        width: 100,
        height: 100,
      ),
      onTap: onTap,
    );
  }
}
