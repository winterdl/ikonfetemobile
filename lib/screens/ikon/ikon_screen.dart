import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/ikon/ikon_screen_bloc.dart';
import 'package:ikonfete/screens/ikon/ikon_screen_header.dart';
import 'package:ikonfete/screens/ikon/ikon_toolbar.dart';
import 'package:ikonfete/zoom_scaffold/menu_ids.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold.dart';
import 'package:ikonfete/zoom_scaffold/zoom_scaffold_screen.dart';

Screen ikonScreen(String fanUid) {
  return Screen(
    title: "Ikon",
    contentBuilder: (context) {
      return IkonScreen(
        bloc: IkonScreenBloc(),
        fanUid: fanUid,
      );
    },
  );
}

class IkonScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final String fanUid;
  final IkonScreenBloc bloc;

  IkonScreen({@required this.bloc, @required this.fanUid}) {
    bloc.dispatch(LoadIkon(fanUid));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<IkonScreenEvent, IkonScreenState>(
        bloc: bloc,
        builder: (ctx, state) {
          if (state.loadIkonResult != null) {
            final result = state.loadIkonResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(result.second),
                    backgroundColor: errorColor,
                  ),
                );
              });
            }
          }

          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildHeader(context, screenSize, state),
                    SizedBox(height: 30),
                    _buildAbout(state),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, Size screenSize, IkonScreenState state) {
    final scaffoldScreenState = ZoomScaffoldScreen.getState(context);
    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          IkonScreenHeader(
            artistName: state.artist?.name ?? "",
            profilePicture: state.artist?.profilePictureUrl ?? null,
            feteScore: state.artist?.feteScore ?? 0,
            height: 240,
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: IkonToolbar(
                width: screenSize.width - 60,
                numFollowers: state.artist?.teamMemberCount ?? 0,
                // todo
                streamActionHandler: () {},
                messageActionHandler: () {
                  scaffoldScreenState.changeActiveScreen(MenuIDs.messaging);
                },
                playActionHandler: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(IkonScreenState state) {
    final readMoreTapHandler = TapGestureRecognizer();
    readMoreTapHandler.onTap = () {};

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("About the Artist", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text(
            state.artist?.bio ?? "",
            softWrap: true,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: "Read More",
              style: TextStyle(color: primaryColor),
              recognizer: readMoreTapHandler,
            ),
          ),
        ],
      ),
    );
  }
}
