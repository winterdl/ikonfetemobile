import 'package:ikonfete/screens/home/home_screen.dart';
import 'package:ikonfete/screens/ikon/ikon_screen.dart';
import 'package:ikonfete/screens/messaging/messaging_screen.dart';
import 'package:ikonfete/screens/music/music_screen.dart';
import 'package:ikonfete/screens/profile/profile_screen.dart';
import 'package:ikonfete/screens/settings/settings_screen.dart';
import 'package:ikonfete/screens/superfans/superfans_screen.dart';
import 'package:ikonfete/screens/team/team_screen.dart';
import 'package:ikonfete/zoom_scaffold/menu_ids.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';
import 'package:meta/meta.dart';

class Menu {
  final List<MenuItem> items;

  Menu({
    this.items,
  });
}

class MenuItem {
  final String id;
  final String title;
  final bool isDefault;
  final bool display;

  MenuItem({
    this.id,
    this.title,
    this.isDefault: false,
    this.display: true,
  });

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  bool operator ==(other) =>
      other is MenuItem && other.id == id && other.title == title;
}

Map<MenuItem, Screen> zoomScaffoldMenuItems(
    {@required bool isArtist, @required String uid}) {
  final menu = <MenuItem, Screen>{};

  menu[MenuItem(id: MenuIDs.profile, title: 'Profile', display: false)] =
      profileScreen;

  menu[MenuItem(id: MenuIDs.home, title: 'Home', isDefault: true)] =
      homeScreen(uid);

  menu[MenuItem(id: MenuIDs.superFans, title: 'Super Fans')] = superfansScreen;

  if (isArtist) {
    menu[MenuItem(id: MenuIDs.team, title: 'Team')] = teamScreen(uid);
  } else {
    // fan menu
    menu[MenuItem(id: MenuIDs.ikon, title: 'Ikon')] = ikonScreen;
  }

  menu[MenuItem(id: MenuIDs.music, title: 'Music')] = musicScreen;
  menu[MenuItem(id: MenuIDs.messaging, title: 'Messaging')] = messagingScreen;
  menu[MenuItem(id: MenuIDs.settings, title: 'Settings')] = settingsScreen(uid);
  return menu;
}

Screen getZoomScaffoldScreen(String menuItemId,
    {@required bool isArtist, @required uid}) {
  final menuItems = zoomScaffoldMenuItems(isArtist: isArtist, uid: uid);
  var menuItem =
      menuItems.keys.firstWhere((item) => item.id == menuItemId, orElse: null);
  if (menuItem == null) {
    menuItem = menuItems.keys.firstWhere((item) => item.isDefault);
  }
  return menuItems[menuItem];
}

Screen defaultScreen({@required bool isArtist, @required String uid}) {
  final menuItem = defaultMenuItem(isArtist: isArtist, uid: uid);
  return zoomScaffoldMenuItems(isArtist: isArtist, uid: uid)[menuItem];
}

MenuItem defaultMenuItem({@required bool isArtist, @required String uid}) {
  final menuItem = zoomScaffoldMenuItems(isArtist: isArtist, uid: uid)
      .keys
      .firstWhere((item) => item.isDefault);
  if (menuItem == null) throw ArgumentError("Default Menu Item not found");
  return menuItem;
}

Menu zoomScaffoldMenu({@required bool isArtist, @required String uid}) {
  return Menu(
      items: zoomScaffoldMenuItems(isArtist: isArtist, uid: uid).keys.toList());
}