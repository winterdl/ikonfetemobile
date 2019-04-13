import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/app_bar_delegate.dart';
import 'package:ikonfete/widget/modal.dart';
import 'package:ikonfete/widget/super_fan/super_fan_tile.dart';
import 'package:ikonfete/widget/themes/theme.dart';

class LeaderBoardScreeen extends StatelessWidget {
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
            //     'Leaderboard',
            //     style: TextStyle(color: IkColors.dark),
            //   ),
            //   centerTitle: true,
            // ),
            body: DefaultTabController(
                length: 3,
                child: SafeArea(
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          child: SliverPersistentHeader(
                            floating: true,
                            pinned: true,
                            delegate: SliverAppBarDelegate(
                              minHeight: sh(50),
                              maxHeight: sh(50),
                              child: Container(
                                color: Colors.white,
                                child: _BuildTabBar(),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Builder(
                      builder: (context) {
                        return TabBarView(
                          children: [
                            _BuildTodayTab(),
                            _BuildTodayTab(),
                            _BuildTodayTab(),
                          ],
                        );
                      },
                    ),
                  ),
                )));
      },
    );
  }
}

class _BuildTodayTab extends StatelessWidget {
  const _BuildTodayTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: <Widget>[
          Builder(
            builder: (BuildContext _context) {
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                key: PageStorageKey(''),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sw(8),
                        vertical: sh(16),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _BuildStatsTile(
                                    percentage: 37, description: 'Active Male'),
                                _BuildStatsTile(
                                  percentage: 19,
                                  description: 'Active Female',
                                ),
                                _BuildStatsTile(
                                  percentage: 19,
                                  description: 'Inactive Fans',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '//TODO',
                                style: IkTheme.of(context)
                                    .smallHint
                                    .copyWith(color: IkColors.lighterGrey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(sw(16)),
                      height: sf(180),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: IkColors.dark.shade200,
                                blurRadius: sw(30))
                          ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: sw(25)),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: SuperFanTile(
                                  onTap: () {},
                                  rank: index + 1,
                                  feteScore: 100 - index - 1),
                            ),
                            CupertinoButton(
                              pressedOpacity: 0.7,
                              onPressed: () {
                                //TODO show dialogue
                              },
                              child: Icon(
                                Icons.more_vert,
                                size: sf(30),
                                color: IkColors.lightGrey,
                              ),
                            ),
                          ],
                        );
                      }, childCount: 100),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BuildTabBar extends StatelessWidget {
  const _BuildTabBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        isScrollable: true,
        unselectedLabelColor: IkColors.lightGrey,
        labelColor: IkColors.dark,
        indicatorColor: primaryColor,
        indicatorWeight: (3),
        indicator: BoxDecoration(
            gradient: LinearGradient(colors: [
              IkColors.primary,
              Colors.transparent,
            ]),
            color: Colors.transparent,
            border: null),
        labelStyle: TextStyle(
          fontSize: sf(14),
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        tabs: [
          Text("Today"),
          Text("This Week"),
          Text("This Month"),
        ]);
  }
}

class _BuildStatsTile extends StatelessWidget {
  const _BuildStatsTile({
    Key key,
    this.description,
    this.percentage,
  }) : super(key: key);

  final String description;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(sw(16)),
          height: sf(8),
          width: sf(8),
          decoration: BoxDecoration(
              color: IkColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(sf(10)))),
        ),
        Text.rich(
          TextSpan(
            text: '$percentage% \n',
            style: IkTheme.of(context)
                .bodyBold
                .copyWith(height: 1, fontSize: sf(16)),
            children: [
              TextSpan(text: description, style: IkTheme.of(context).bodyHint),
            ],
          ),
        )
      ],
    );
  }
}
