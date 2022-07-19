import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/Helper/CustomRoute.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Helper/LocationService.dart';
import 'package:nawras_app/Helper/connectivity_status.dart';
import 'package:nawras_app/Providers/AppSettingsProvider.dart';
import 'package:nawras_app/Providers/CategoryProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:nawras_app/Providers/PageLoadingProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:nawras_app/Providers/ScheduleProvider.dart';
import 'package:nawras_app/Providers/providerStates.dart';
import 'package:nawras_app/Screens/DetailsProductScreen/DetailsProductScreen.dart';
import 'package:nawras_app/Screens/FeedbackScreen/FeedbackScreen.dart';
import 'package:nawras_app/Screens/LanguageScreen/LanguageScreen.dart';
import 'package:nawras_app/Screens/LoginScreen/LoginScreen.dart';
import 'package:nawras_app/Screens/MapScreen/MapScreen.dart';
import 'package:nawras_app/Screens/MarketHistoryOrderItemListScreen/MarketHistoryOrderItemListScreen.dart';
import 'package:nawras_app/Screens/ProfileScreen/ProfileScreen.dart';
import 'package:nawras_app/Screens/ScheduleScreen/ScheduleScreen.dart';
import 'package:nawras_app/Screens/SubCategoryScreen/SubCategoryScreen.dart';
import 'package:nawras_app/Screens/SubScheduleScreen/SubScheduleScreen.dart';
import 'package:nawras_app/Screens/TotalProductsScreen/TotalProductsScreen.dart';
import 'package:provider/provider.dart';
import 'Constants/ColorConstants.dart';
import 'Providers/AuthProvider.dart';
import 'Screens/AboutScreen/AboutScreen.dart';
import 'Screens/ContactScreen/ContactScreen.dart';
import 'Screens/DetailRequestScreen/DetailRequestScreen.dart';
import 'Screens/HomeScreen/HomeScreen.dart';
import 'Screens/MapIOSScreen/MapIOSScreen.dart';
import 'Screens/MarketingScreen/MarketingScreen.dart';
import 'Screens/SetMarketScreen/SetMarketScreen.dart';
import 'Screens/SplashScreen/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(Providers());
}

class Providers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (context) => AppSettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Language(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OtherProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProviderStates(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScheduleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScheduleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationService(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppTextStyle(),
        ),
      ],
      child: StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusControllerStream,
          child: MyApp()),
    );
  }
}

class MyApp extends StatelessWidget {
  Future<void> getLanguage(BuildContext context) async {
    await Provider.of<Language>(context, listen: false)
        .getLanguageDataInLocal();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLanguage(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Container(
                  alignment: Alignment.center,
                  color: Color(0xffEDF2F7),
                  child: LoadingIndicator(),
                )
              : Consumer<Language>(
                  builder: (context, language, _) => MaterialApp(
                    theme: ThemeData(
                      fontFamily: language.languageCode == "ar" ||
                              language.languageCode == "kr"
                          ? "NRT"
                          : "Rewe",
                      primaryColor: PaletteColors.mainAppColor,
                      primarySwatch: Colors.red,
                      appBarTheme: AppBarTheme(
                        elevation: 3,
                      ),
                      scaffoldBackgroundColor: PaletteColors.whiteBg,
                      pageTransitionsTheme: PageTransitionsTheme(
                        builders: {
                          TargetPlatform.android: CustomPageTransitionBuilder(),
                          TargetPlatform.iOS: CustomPageTransitionBuilder(),
                        },
                      ),
                    ),
                    title: 'Nawras',
                    initialRoute: '/',
                    debugShowCheckedModeBanner: false,
                    routes: {
                      '/': (context) => SplashScreen(),
                      '/home': (context) => HomeScreen(),
                      '/login': (context) => LoginScreen(),
                      '/about': (context) => AboutScreen(),
                      '/contact': (context) => ContactScreen(),
                      '/subCategory': (context) => SubCategoryScreen(),
                      '/profile': (context) => ProfileScreen(),
                      '/detailRequest': (context) => DetailRequestScreen(),
                      '/feedback': (context) => FeedbackScreen(),
                      '/TotalProducts': (context) => TotalProductsScreen(),
                      '/map': (context) => MapScreen(),
                      '/mapIOS': (context) => MapIOSScreen(),
                      '/detailsProduct': (context) => DetailsProductScreen(),
                      '/marketHistoryOrderItemList': (context) =>
                          MarketHistoryOrderItemList(),
                      '/marketing': (context) => MarketingScreen(),
                      '/language': (context) => LanguageScreen(),
                      '/schedule': (context) => ScheduleScreen(),
                      '/subSchedule': (context) => SubScheduleScreen(),
                      '/setMarket': (context) => SetMarketScreen(),
                    },
                  ),
                ),
    );
  }
}
