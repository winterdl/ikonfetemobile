import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/event_slide.dart';
import 'package:ikonfete/widget/post_cards.dart';
import 'package:ikonfete/widget/post_cards/music_post_card.dart';
import 'package:ikonfete/widget/post_cards/video_post_card.dart';

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
                onNotification: (not) {},
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
                            child: _BuildTabs(),
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
                                    // SliverToBoxAdapter(
                                    //   child: ValueListenableBuilder<bool>(
                                    //     valueListenable: isScrolledTop,
                                    //     builder: (BuildContext context,
                                    //         isScrolled, Widget child) {
                                    //       print(isScrolled);
                                    //       return AnimatedContainer(
                                    //         child: SizedBox(),
                                    //         duration:
                                    //             Duration(milliseconds: 500),
                                    //         height: isScrolled ? 0 : sh(100),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    SliverPersistentHeader(
                                      floating: false,
                                      pinned: false,
                                      delegate: _SliverAppBarDelegate(
                                        minHeight: sh(120),
                                        maxHeight: sh(120),
                                        child: Container(
                                          color: Colors.white,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sh(20)),
                                            child: _BuildStories(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: sw(25)),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                          if (index == 0) {
                                            return TextPostCard();
                                          }
                                          if (index.isOdd) {
                                            return VideoPostCard();
                                          }
                                          if (index.isEven) {
                                            return MusicPostCard();
                                          }
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

class _BuildTabs extends StatelessWidget {
  const _BuildTabs({
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Artist Feed"),
          ),
          Text("Team Feed"),
          Text("LeaderBoard"),
        ]);
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
            width: sw(50),
            height: sh(80),
            margin: EdgeInsets.only(right: sw(20)),
            child: Column(
              children: <Widget>[
                AspectRatio(
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
                Text(
                  'Name',
                  style: TextStyle(
                    height: 1.2,
                    color: IkColors.lightGrey,
                  ),
                )
              ],
            ),
          );
        },
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
