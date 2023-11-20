import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:spider_robot/src/shared/utils/functions.dart';
import 'package:spider_robot/src/shared/widgets/battery_level.dart';
import 'package:spider_robot/src/shared/widgets/custom_app_bar.dart';
import 'package:spider_robot/src/shared/widgets/custom_drawer.dart';
import 'package:spider_robot/src/shared/widgets/modern_camera.dart';
import 'package:spider_robot/src/shared/widgets/robot_location.dart';
import 'package:spider_robot/src/shared/widgets/control_widget.dart';
import 'package:spider_robot/src/shared/widgets/wifi_level.dart';
import 'package:latlong2/latlong.dart';
import '../../../settings/language/controllers/language_controller.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeController _homeController;
  late final LanguageController _languageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _homeController = Modular.get<HomeController>();
    _languageController = Modular.get<LanguageController>();
    _languageController.initLanguage();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      _homeController.updateTabIndex(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: _languageController.localeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bool isDarkThemeSelected =
              Theme.of(context).brightness == Brightness.dark;

          final Color defaultSelectedColor = Theme.of(context).primaryColor;
          final Color defaultColor =
              Theme.of(context).textTheme.bodyLarge!.color!;

          final Color darkSelectedColor =
              Theme.of(context).colorScheme.secondary;
          final Color darkDefaultColor =
              Theme.of(context).colorScheme.onSurface;

          final Color selectedColor =
              isDarkThemeSelected ? darkSelectedColor : defaultSelectedColor;
          final Color defaultItemColor =
              isDarkThemeSelected ? darkDefaultColor : defaultColor;

          return WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
              appBar: CustomAppBar(
                title: translate('homeTitle'),
              ),
              drawer: const CustomDrawer(),
              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildHomeContent(context, isDarkThemeSelected),
                  const ControlWidget(),
                ],
              ),
              bottomNavigationBar: ValueListenableBuilder<int>(
                valueListenable: _homeController,
                builder: (context, currentIndex, child) {
                  return BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      _tabController.animateTo(index);
                    },
                    items: bottomNavBarItems(selectedColor, defaultItemColor),
                    selectedItemColor: selectedColor,
                    unselectedItemColor: defaultItemColor,
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                  );
                },
              ),
            ),
          );
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _buildHomeContent(BuildContext context, bool isDarkThemeSelected) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const RobotLocation(
              robotPosition: LatLng(51.509364, -0.128928),
              destinationPosition: LatLng(51.509564, -0.128928),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: isDarkThemeSelected
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    translate('status_robots'),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 170.0,
                        height: 120.0,
                        child: AnimatedBatteryWidget(batteryPercentage: 75),
                      ),
                      SizedBox(width: 10.0),
                      SizedBox(
                        width: 120.0,
                        height: 20.0,
                        child: AnimatedWifiWidget(strength: 3),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 300,
                    height: 205,
                    child: ModernCameraWidget(
                      cameraActivationText: translate('cameraActivationPrompt'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavBarItems(
      Color selectedColor, Color defaultItemColor) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: translate('bottomNavHome'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.bug_report),
        label: translate('bottomNavControlSpider'),
      ),
    ];
  }

  Future<bool> _onBackPressed() async {
    return await showExitDialog(context);
  }
}
