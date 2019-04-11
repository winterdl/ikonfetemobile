import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/screens/ikon/artist_profile_header.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';

Screen ikonScreenOld(String fanUid) {
  return Screen(
    title: "Ikon",
    contentBuilder: (context) {
      return IkonScreenOld();
    },
  );
}

class IkonScreenOld extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverPersistentHeader(
                pinned: true,
                delegate: ArtistProfileHeader(
                  artistName: "ARTIST NAME",
                  artistScore: 0,
                  headerImageUrl: null,
                  numFollowers: 0,
                  maxExtent: _screenSize.height / 2.9,
                  minExtent: 80.0,
                  onScroll: (double offset) {},
                  onScrollToTop: (bool isAtTop) {},
                  streamActionHandler: () {
//                    zoomScaffoldScreenState.changeActiveScreen(MenuIDs.home);
                  },
                  messageActionHandler: () {
//                    zoomScaffoldScreenState.changeActiveScreen(MenuIDs.inbox);
                  },
                  playActionHandler: () {},
                ),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              slivers: <Widget>[
                new SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                _buildBody(),
                _buildPopularTracksList()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularTracksList() {
    return SliverPadding(
      padding: const EdgeInsets.only(
          top: 0.0, bottom: 25.0, left: 25.0, right: 25.0),
      sliver: SliverFixedExtentList(
        itemExtent: 64.0 + 20,
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ListTile(
                contentPadding: EdgeInsets.all(0.0),
                leading: CircleAvatar(
                  radius: 32.0,
                  backgroundImage:
                      AssetImage('assets/images/onboard_background1.png'),
                ),
                title: Text(
                  'Music Title',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(Icons.more_vert),
                subtitle: Text(
                  'Albun 3:30',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF0707070),
                  ),
                ),
                enabled: true,
                onTap: () {
                  /* react to the tile being tapped */
                });
          },
          childCount: 10,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SliverPadding(
      padding: const EdgeInsets.all(25.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            SizedBox(
              height: 10.0,
            ),
            _buildAboutArtist("bio"),
            _buildArtistImages(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 42.0,
                ),
                Text(
                  "Popular Tracks",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: "SanFranciscoDisplay",
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistImages() {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0 / 1.0,
            child: GestureDetector(
              onTap: null,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/onboard_background1.png"),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),

        //padding
        SizedBox(width: 13.0),

        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0 / 1.0,
            child: GestureDetector(
              onTap: null,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/onboard_background1.png"),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ),

        //padding
        SizedBox(width: 13.0),

        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0 / 1.0,
            child: GestureDetector(
              onTap: null,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        blueOverlay.withOpacity(0.5), BlendMode.multiply),
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/onboard_background1.png"),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "+5",
                    style: TextStyle(color: Colors.white, fontSize: 19.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutArtist(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "About The Artist",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black54,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
            bio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: GestureDetector(
            onTap: () {
//              Navigator.of(context).push(
//                new CupertinoPageRoute(
//                  builder: (ctx) => ArtistBioScreen(bio: bio),
//                ),
//              );
            },
            child: Text(
              "Read More",
              style: TextStyle(color: primaryColor, fontSize: 15.0),
            ),
          ),
        ),
      ],
    );
  }
}

class ArtistBioScreen extends StatelessWidget {
  final String bio;

  ArtistBioScreen({@required this.bio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: new IconButton(
            icon: new Icon(FontAwesome5Icons.angleLeft, color: Colors.black54),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: new Text(
          "BIO",
          style: new TextStyle(
            fontFamily: 'bebas-neue',
            fontSize: 25.0,
            color: Colors.black54,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding:
              EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0, top: 20.0),
          child: Text(
            bio,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
