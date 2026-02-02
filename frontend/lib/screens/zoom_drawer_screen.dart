import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'menu_screen.dart';
import 'main_navigation_screen.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();
    // Use widget binding to delay if necessary, or just add listener to the controller's notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawerController.stateNotifier?.addListener(_drawerStateListener);
    });
  }

  void _drawerStateListener() {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    final state = _drawerController.stateNotifier?.value;
    if (state == DrawerState.open) {
      navProvider.setDrawerOpen(true);
    } else if (state == DrawerState.closed) {
      navProvider.setDrawerOpen(false);
    }
  }

  @override
  void dispose() {
    _drawerController.stateNotifier?.removeListener(_drawerStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: const MenuScreen(),
      mainScreen: const MainNavigationScreen(),
      borderRadius: 24.0,
      showShadow: true,
       angle: -0.0,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      slideWidth: MediaQuery.of(context).size.width * 0.60,
      menuBackgroundColor: const Color(0xFF3A4F9B),
      style: DrawerStyle.defaultStyle,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.fastOutSlowIn,
    );
  }
}
