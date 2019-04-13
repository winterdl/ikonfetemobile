import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/team_feed/partials/activity_tile.dart';
import 'package:ikonfete/screens/team_feed/partials/feed_avatar.dart';
import 'package:ikonfete/widget/super_fan/super_fan_tile.dart';
import 'package:ikonfete/widget/themes/theme.dart';

// Widget TeamFeed(BuildContext context, String uid) {
//   return ArtistHomeScreen();
// }

class TeamFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (ctx, appState) {
        return Scaffold(
          // appBar: AppBar(
          //   elevation: 0.0,
          //   backgroundColor: IkColors.white,
          //   title: Text(
          //     'Team Feed',
          //     style: TextStyle(color: IkColors.dark),
          //   ),
          //   centerTitle: true,
          // ),
          body: SafeArea(
            child: Center(
              child: Container(
                height: mq.size.height,
                width: mq.size.width,
                padding: EdgeInsets.symmetric(horizontal: sw(16)),
                alignment: Alignment.center,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: sh(27)),
                    Text(
                      'Superfans',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: sf(14)),
                    ),
                    SizedBox(height: sh(27)),
                    Row(children: <Widget>[
                      SuperFanTile(
                        rank: 1,
                        feteScore: 99,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CupertinoButton(
                          onPressed: () {},
                          pressedOpacity: 0.9,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'See all',
                              style: IkTheme.of(context)
                                  .button
                                  .copyWith(color: IkColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: sh(27)),
                    Divider(height: 0),
                    _BuildRecent(),
                    _BuildOlder(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuildRecent extends StatelessWidget {
  const _BuildRecent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: sh(20)),
          Text('RECENT',
              style: IkTheme.of(context)
                  .smallHint
                  .copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: sh(20)),
          //TODO make more accessible
          ActivityTile(),
          ActivityTileWarn(),
        ],
      ),
    );
  }
}

class _BuildOlder extends StatelessWidget {
  const _BuildOlder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: sh(20)),
          Text('OLDER',
              style: IkTheme.of(context)
                  .smallHint
                  .copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: sh(20)),
          //TODO make more accessible
          ActivityTile(),
          ActivityTileWarn(),
          ActivityTileFollow(),
        ],
      ),
    );
  }
}
