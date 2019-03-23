import 'package:flutter/material.dart';
import 'package:ikonfete/zoom_scaffold/menu.dart';
import 'package:ikonfete/zoom_scaffold/menu_screen.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

class ZoomScaffoldScreen extends StatefulWidget {
  final bool isArtist;
  final String uid;
  final String screenId;
  final Map<String, String> params;

  ZoomScaffoldScreen({
    @required this.isArtist,
    @required this.uid,
    @required this.screenId,
    this.params,
  });

  @override
  ZoomScaffoldScreenState createState() => ZoomScaffoldScreenState();

  static ZoomScaffoldScreenState getState(BuildContext context) {
    ZoomScaffoldScreenState zoomScaffoldScreenState =
        context.ancestorStateOfType(ZoomScaffoldStateTypeMatcher());
    return zoomScaffoldScreenState;
  }
}

class ZoomScaffoldScreenState extends State<ZoomScaffoldScreen> {
  String selectedMenuItemId;
  Screen activeScreen;

  @override
  void initState() {
    super.initState();
    selectedMenuItemId =
        defaultMenuItem(isArtist: widget.isArtist, uid: widget.uid).id;
    activeScreen = defaultScreen(isArtist: widget.isArtist, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: MenuScreen(
        menu: zoomScaffoldMenu(isArtist: widget.isArtist, uid: widget.uid),
        selectedItemId: selectedMenuItemId,
        onMenuItemSelected: _onMenuItemSelected,
      ),
      contentScreen: activeScreen,
    );
  }

  void _onMenuItemSelected(String itemId) {
    selectedMenuItemId = itemId;
    final screen = getZoomScaffoldScreen(selectedMenuItemId,
        isArtist: widget.isArtist, uid: widget.uid);
    setState(() => activeScreen = screen);
  }

  void changeActiveScreen(String newScreenId) {
    _onMenuItemSelected(newScreenId);
  }
}

class ZoomScaffoldStateTypeMatcher extends TypeMatcher {
  @override
  bool check(dynamic object) {
    return object is ZoomScaffoldScreenState;
  }
}
