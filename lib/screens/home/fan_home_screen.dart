import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/post_cards.dart';

Widget fanHomeScreen(BuildContext context, String uid) {
  return FanHomeScreen();
}

class FanHomeScreen extends StatefulWidget {
  @override
  _FanHomeScreenState createState() => _FanHomeScreenState();
}

class _FanHomeScreenState extends State<FanHomeScreen> {
  final _controller = ScrollController();

  final ValueNotifier<bool> isScrolledTop = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (ctx, appState) {
        return DefaultTabController(
            length: 3,
            child: SafeArea(
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (not) {
                  if (not.metrics.maxScrollExtent == not.metrics.pixels) {
                    isScrolledTop.value = true;
                  }
                },
                child: NestedScrollView(
                  controller: _controller,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        child: SliverPersistentHeader(
                          pinned: false,
                          floating: false,
                          delegate: _SliverAppBarDelegate(
                            minHeight: sh(300),
                            maxHeight: sh(300),
                            child: Container(
                              width: mq.size.width,
                              height: sh(300),
                              child: PageView.builder(
                                controller:
                                    PageController(viewportFraction: .9),
                                itemBuilder: (ctx, index) {
                                  return EventSlide();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          minHeight: sh(50),
                          maxHeight: sh(50),
                          child: Container(
                            color: Colors.white,
                            child: TabBar(
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
                                  fontSize: sf(16),
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                                tabs: [
                                  Text("Artist Feed"),
                                  Text("Team Feed"),
                                  Text("LeaderBoard"),
                                ]),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Stack(
                          children: <Widget>[
                            Builder(
                              builder: (BuildContext context) {
                                return CustomScrollView(
                                  key: PageStorageKey('ArtistFeed'),
                                  slivers: <Widget>[
                                    SliverOverlapInjector(
                                      handle: NestedScrollView
                                          .sliverOverlapAbsorberHandleFor(
                                              context),
                                    ),
                                    SliverPersistentHeader(
                                      floating: false,
                                      pinned: true,
                                      delegate: _SliverAppBarDelegate(
                                        minHeight: sh(50),
                                        maxHeight: sh(50),
                                        child: Container(
                                          color: Colors.white,
                                          child:
                                              Container(child: _BuildStories()),
                                        ),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sw(25)),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                          return VideoPostCard();
                                        }),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return Text('hello');
                          },
                        ),
                      ),
                      SafeArea(
                        top: false,
                        bottom: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return Text('hello');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}

class _BuildStories extends StatelessWidget {
  const _BuildStories({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.size.width,
      height: sh(50),
      child: ListView.builder(
        padding: EdgeInsets.only(left: sw(25)),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: sw(20)),
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: IkColors.primary, width: 2)),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: sw(24),
                  child: Container(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventSlide extends StatelessWidget {
  const EventSlide({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: sw(16)),
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: sh(100),
                margin: EdgeInsets.symmetric(horizontal: sw(26)),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: sf(20), color: Color(0xFF3e131c))
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/onboard_background3.png',
                      )),
                  borderRadius: BorderRadius.all(Radius.circular(sw(8))),
                ),
                height: sh(180),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: sh(16)),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: sw(16)),
                        Tags(title: 'CONCERT'),
                        SizedBox(width: sw(16)),
                        Tags(title: 'ROCK'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sh(24)),
          Text(
            'Imagine Dragons',
            style: TextStyle(fontSize: sf(20), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sh(8)),
          Text('Moscow, big sports arena | Luzhniki',
              style: TextStyle(fontSize: sf(15))),
          SizedBox(height: sh(8)),
          Text('August 29, 19:00', style: TextStyle(fontSize: sf(15))),
        ],
      ),
    );
  }
}

class Tags extends StatelessWidget {
  const Tags({
    Key key,
    @required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: sw(6), vertical: sw(6)),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: sf(12),
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          borderRadius: BorderRadius.all(Radius.circular(sw(4))),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
