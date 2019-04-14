import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/app_bar_delegate.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/super_fan/super_fan_tile.dart';
import 'package:ikonfete/widget/themes/theme.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

final messagingScreen = Screen(
  title: "Messaging",
  contentBuilder: (ctx) {
    print("Messaging Screen");
    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
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
                      ],
                    );
                  },
                ),
              ),
            )));
  },
);

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
          Text("Live"),
          Text("Direct Messaging"),
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
                .copyWith(height: .4, fontSize: sf(16)),
            children: [
              TextSpan(text: description, style: IkTheme.of(context).bodyHint),
            ],
          ),
        )
      ],
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
                        horizontal: sw(16),
                        vertical: sh(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'SESSION STATS \n',
                                    children: [
                                      TextSpan(
                                          text: 'This Month',
                                          style: IkTheme.of(context)
                                              .smallBold
                                              .copyWith(
                                                  height: 1.0,
                                                  color: IkColors.lightGrey)),
                                    ],
                                  ),
                                  style: IkTheme.of(context).bodyBold,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.only(left: sw(16)),
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
                          ),
                          SizedBox(height: sh(28)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  text: '6\n',
                                  children: [
                                    TextSpan(
                                        text: 'Sessions',
                                        style: IkTheme.of(context)
                                            .smallBold
                                            .copyWith(
                                                height: 1.2,
                                                color: IkColors.lightGrey)),
                                  ],
                                ),
                                style: IkTheme.of(context)
                                    .display2Bold
                                    .copyWith(height: 1.2),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: '12k\n',
                                  children: [
                                    TextSpan(
                                        text: 'Messages',
                                        style: IkTheme.of(context)
                                            .smallBold
                                            .copyWith(
                                                height: 1.2,
                                                color: IkColors.lightGrey)),
                                  ],
                                ),
                                style: IkTheme.of(context)
                                    .display2Bold
                                    .copyWith(height: 1.2),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: '0\n',
                                  children: [
                                    TextSpan(
                                        text: 'Files Shared',
                                        style: IkTheme.of(context)
                                            .smallBold
                                            .copyWith(
                                                height: 1.2,
                                                color: IkColors.lightGrey)),
                                  ],
                                ),
                                style: IkTheme.of(context)
                                    .display2Bold
                                    .copyWith(height: 1.2),
                              ),
                            ],
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(sw(16)),
                      height: sf(150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(sw(8))),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: IkColors.dark.shade200, blurRadius: sw(30))
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sw(16), vertical: sh(8)),
                      sliver: SliverFillRemaining(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text.rich(
                                      TextSpan(
                                        text: 'FANBASE \n',
                                        children: [
                                          TextSpan(
                                              text: 'Online Now',
                                              style: IkTheme.of(context)
                                                  .smallBold
                                                  .copyWith(
                                                      height: 1.0,
                                                      color:
                                                          IkColors.lightGrey)),
                                        ],
                                      ),
                                      style: IkTheme.of(context).bodyBold,
                                    ),
                                    SizedBox(height: sh(20)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        //TODO
                                        Container(
                                          decoration: BoxDecoration(
                                              color: IkColors.lighterColdGrey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(1000))),
                                          width: sf(150),
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Center(
                                              child: Text(
                                                '//TODO',
                                                style: TextStyle(
                                                    color:
                                                        IkColors.lighterGrey),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            _BuildStatsTile(
                                                percentage: 40,
                                                description: "Female"),
                                            _BuildStatsTile(
                                                percentage: 60,
                                                description: "Male")
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.all(sw(16)),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(sw(8))),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: IkColors.dark.shade200,
                                        blurRadius: sw(30))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: sf(16)),
                            SizedBox(
                              width: mq.size.width,
                              child: CupertinoButton(
                                minSize: sf(45),
                                color: IkColors.primary,
                                child: Text('GO LIVE NOW'),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(height: sf(8))
                          ],
                        ),
                      )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
