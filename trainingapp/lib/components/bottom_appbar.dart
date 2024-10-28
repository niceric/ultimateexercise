import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/states/screen_index_provider.dart';

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _screenindexprovider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = _screenindexprovider.fetchCurrentScreenIndex;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      selectedItemColor: const Color.fromARGB(255, 69, 246, 252),
      unselectedItemColor: Colors.grey,
      iconSize: 50,
      currentIndex: currentScreenIndex,
      onTap: (value) => _screenindexprovider.updateScreenIndex(value, context),
      items: [
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
              (currentScreenIndex == 0) ? Icons.home : Icons.home_outlined),
          // backgroundColor: const Color.fromARGB(255, 255, 255,
          // 255) // provide color to any one icon as it will overwrite the whole bottombar's color ( if provided any )
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
              (currentScreenIndex == 1) ? Icons.list : Icons.list_outlined),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon(
            (currentScreenIndex == 2) ? Icons.add_circle : Icons.add_circle,
            color: const Color.fromARGB(255, 134, 226, 137),
            size: 80,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon((currentScreenIndex == 3)
              ? Icons.stacked_bar_chart
              : Icons.stacked_bar_chart_outlined),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: Icon((currentScreenIndex == 4)
              ? Icons.settings
              : Icons.settings_outlined),
        ),
      ],
    );
    //body: screens[currentScreenIndex],
  }
}
