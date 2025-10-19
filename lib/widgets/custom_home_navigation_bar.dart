import 'package:centranews/models/language_localization.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/localization_provider.dart';

class CustomHomeNavigationBar extends ConsumerStatefulWidget {
  const CustomHomeNavigationBar({
    super.key,
    required this.setCurrentPageIndex,
    required this.currentPageIndex,
  });

  final void Function(int index) setCurrentPageIndex;
  final int currentPageIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomHomeNavigationBarState();
}

class _CustomHomeNavigationBarState
    extends ConsumerState<CustomHomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          currentTheme.textTheme.navigationLabelStyle,
        ),
      ),
      child: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            widget.setCurrentPageIndex(index);
          });
        },
        selectedIndex: widget.currentPageIndex,
        destinations: navigatorIcons(localization),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        indicatorColor: currentTheme.currentColorScheme.bgSecondary,
      ),
    );
  }

  List<Widget> navigatorIcons(LanguageLocalizationTexts localization) {
    var currentTheme = ref.watch(themeProvider);
    return [
      NavigationDestination(
        selectedIcon: Icon(
          Icons.article_outlined,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        icon: Icon(
          Icons.article,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        label: localization.news,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.explore,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        label: localization.discovery,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.bookmark,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        selectedIcon: Icon(Icons.bookmark_border_outlined),
        label: localization.bookmarks,
      ),
    ];
  }
}
