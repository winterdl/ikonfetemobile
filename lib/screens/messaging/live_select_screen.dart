import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/widget/app_bar_delegate.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/super_fan/super_fan_tile.dart';
import 'package:ikonfete/widget/themes/theme.dart';

class LiveSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (ctx, appState) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: sw(16)),
              width: mq.size.width,
              height: mq.size.height,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  new _BuildHeader(),
                  SliverPersistentHeader(
                    pinned: false,
                    floating: true,
                    delegate: SliverAppBarDelegate(
                        maxHeight: sh(250),
                        minHeight: sh(250),
                        child: Container(
                          color: IkColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: sh(40)),
                              Text('Invite Fans',
                                  style: IkTheme.of(context).subhead1),
                              SizedBox(height: sh(30)),
                              SearchField(
                                onChanged: (val) {},
                              ),
                              SizedBox(height: sh(27)),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: sw(100),
                                    height: sh(40),
                                    child: IkOutlineButton(
                                      padding: EdgeInsets.zero,
                                      foregroundColor:
                                          IkColors.primary.withOpacity(.5),
                                      color: IkColors.primary,
                                      onPressed: () {},
                                      child: Text('SelectAll'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: sw(16),
                                  ),
                                  SizedBox(
                                    width: sw(100),
                                    height: sh(40),
                                    child: IkOutlineButton(
                                      padding: EdgeInsets.zero,
                                      foregroundColor:
                                          IkColors.primary.withOpacity(.5),
                                      color: IkColors.primary,
                                      onPressed: () {},
                                      child: Text('Select Top 10'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _BuildTile(
                        feteScore: 100 - index - 1,
                        rank: index + 1,
                        isChecked: true,
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: kToolbarHeight,
        maxHeight: kToolbarHeight,
        child: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.all(8),
                pressedOpacity: 0.7,
                onPressed: () {},
                child: Icon(
                  Icons.close,
                  color: IkColors.dark,
                ),
              ),
              const Spacer(),
              Text(
                'Start Session',
                style: IkTheme.of(context)
                    .subhead1
                    .copyWith(color: IkColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTile extends StatefulWidget {
  const _BuildTile({
    Key key,
    this.title,
    this.isChecked = false,
    this.rank,
    this.feteScore,
    this.onSelect,
  }) : super(key: key);

  final bool isChecked;
  final String title;
  final int rank;
  final int feteScore;
  final Function onSelect;

  @override
  __BuildTileState createState() => __BuildTileState();
}

class __BuildTileState extends State<_BuildTile> {
  bool isChecked;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.9,
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SuperFanTile(
            onTap: null,
            rank: widget.rank,
            feteScore: widget.feteScore,
          ),
          isChecked
              ? Icon(
                  Icons.add_circle_outline,
                  color: IkColors.primary,
                  size: sf(22),
                )
              : Icon(
                  Icons.check_circle,
                  size: sf(22),
                  color: IkColors.primary,
                ),
        ],
      ),
    );
  }
}
