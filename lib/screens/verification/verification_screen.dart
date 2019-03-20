import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_config.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/verification/verification_bloc.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';

Widget verificationScreen(BuildContext context, String uid) {
  return BlocProvider<VerificationBloc>(
    bloc: VerificationBloc(appConfig: AppConfig.of(context)),
    child: VerificationScreen(uid: uid),
  );
}

class VerificationScreen extends StatefulWidget {
  final String uid;

  VerificationScreen({@required this.uid});

  @override
  _VerificationScreenState createState() {
    return new _VerificationScreenState();
  }
}

class _VerificationScreenState extends State<VerificationScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  Future<bool> _willPop(BuildContext context) async {
    bool canClose = Navigator.canPop(context);
    return canClose;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VerificationBloc>(context);
    return WillPopScope(
      onWillPop: () => _willPop(context),
      child: BlocBuilder<VerificationScreenEvent, VerificationScreenState>(
        bloc: bloc,
        builder: (BuildContext context, VerificationScreenState state) {
          if (state.addFacebookResult != null) {
            final result = state.addFacebookResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(result.second),
                  backgroundColor: errorColor,
                ));
              });
            }
          }

          if (state.addTwitterResult != null) {
            final result = state.addTwitterResult;
            if (!result.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(result.second),
                  backgroundColor: errorColor,
                ));
              });
            }
          }

          if (state.verificationResult != null) {
            final result = state.verificationResult;
            if (result.first) {
              // navigate to pending verification screen
              ScreenUtils.onWidgetDidBuild(() {
                Navigator.of(context).pushReplacementNamed(
                    Routes.pendingVerificationScreen(uid: widget.uid));
              });
            } else {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(result.second),
                  backgroundColor: errorColor,
                ));
              });
            }
          }

//          if (state.hasError) {
//            ScreenUtils.onWidgetDidBuild(() {
//              scaffoldKey.currentState
//                  .showSnackBar(SnackBar(content: Text(state.errorMessage)));
//            });
//          } else if (state.pendingVerificationResult != null) {
//            if (state.pendingVerificationResult.first) {
//              ScreenUtils.onWidgetDidBuild(() {
//                Navigator.of(context).pushReplacementNamed(
//                    Routes.pendingVerification(
//                        uid: artistVerificationBloc.uid));
//              });
//            } else {
//              ScreenUtils.onWidgetDidBuild(() {
//                scaffoldKey.currentState.showSnackBar(SnackBar(
//                    content: Text(state.pendingVerificationResult.second)));
//              });
//            }
//          }

          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomPadding: false,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  OverlayBuilder(
                    child: Container(),
                    showOverlay: state.isLoading,
                    overlayBuilder: (context) => HudOverlay.getOverlay(),
                  ),
                  _buildTitleAndBackButton(context),
                  SizedBox(height: 20.0),
                  _buildIntroText(),
                  SizedBox(height: 30.0),
                  VerificationForm(
                    formKey: formKey,
                    verificationScreenState: state,
                  ),
                  Expanded(child: Container()),
                  _buildButtons(state),
                  SizedBox(height: 40.0)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleAndBackButton(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "VERIFICATION",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Navigator.canPop(context)
                ? IconButton(
                    icon: Icon(CupertinoIcons.back, color: Color(0xFF181D28)),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : Container(),
          ],
        )
      ],
    );
  }

  Widget _buildIntroText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        text: "Kindly provide additional information to\n"
            "get your account verified",
      ),
    );
  }

  Widget _buildButtons(VerificationScreenState state) {
    final bloc = BlocProvider.of<VerificationBloc>(context);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
          width: screenSize.width - 80,
          height: 50.0,
          defaultColor: primaryButtonColor,
          activeColor: primaryButtonActiveColor,
          text: "SUBMIT",
          // REGISTER
          onTap: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              bloc.dispatch(SubmitVerification(widget.uid));
            }
          },
        ),
      ],
    );
  }
}

class VerificationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VerificationScreenState verificationScreenState;

  const VerificationForm(
      {Key key, @required this.formKey, @required this.verificationScreenState})
      : super(key: key);

  @override
  _VerificationFormState createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  TextEditingController facebookTextController;
  TextEditingController twitterTextController;

  @override
  void initState() {
    super.initState();
    facebookTextController = TextEditingController();
    twitterTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final facebookSetup =
        !StringUtils.isNullOrEmpty(widget.verificationScreenState.facebookId);
    final twitterSetup =
        !StringUtils.isNullOrEmpty(widget.verificationScreenState.twitterId);

    if (facebookSetup) {
      facebookTextController.text = widget.verificationScreenState.facebookId;
    } else {
      facebookTextController.text = "";
    }

    if (twitterSetup) {
      twitterTextController.text =
          widget.verificationScreenState.twitterUsername;
    } else {
      twitterTextController.text = "";
    }

    final bloc = BlocProvider.of<VerificationBloc>(context);

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildFacebookFormItem(),
            SizedBox(height: 20.0),
            _buildTwitterFormItem(),
            SizedBox(height: 20.0),
            LoginFormField(
              placeholder: "Bio",
              validator: FormFieldValidators.notEmpty("Bio"),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              maxLines: 3,
              onSaved: (String val) => bloc.dispatch(AddBio(val)), // todo:
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookFormItem() {
    final verificationBloc = BlocProvider.of<VerificationBloc>(context);
    final facebookSetup =
        !StringUtils.isNullOrEmpty(widget.verificationScreenState.facebookId);

    return Row(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
          width: 50.0,
          height: 50.0,
          defaultColor: facebookColor,
          activeColor: facebookColor.withOpacity(0.7),
          child: Icon(ThemifyIcons.facebook, color: Colors.white),
          // REGISTER
          onTap: () => verificationBloc.dispatch(AddFacebook()), // todo:
        ),
        Padding(padding: EdgeInsets.only(right: 10.0)),
        Expanded(
          child: LoginFormField(
            placeholder: "Facebook ID",
            keyboardType: TextInputType.text,
            enabled: false,
            controller: facebookTextController,
            fillColor: !facebookSetup
                ? Colors.red.withOpacity(0.4)
                : facebookColor.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildTwitterFormItem() {
    final verificationBloc = BlocProvider.of<VerificationBloc>(context);
    final twitterSetup =
        !StringUtils.isNullOrEmpty(widget.verificationScreenState.twitterId);
    return Row(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        PrimaryButton(
          width: 50.0,
          height: 50.0,
          defaultColor: twitterColor,
          activeColor: twitterColor.withOpacity(0.7),
          child: Icon(ThemifyIcons.twitter, color: Colors.white),
          // REGISTER
          onTap: () => verificationBloc.dispatch(AddTwitter()), // todo:
        ),
        Padding(padding: EdgeInsets.only(right: 10.0)),
        Expanded(
          child: LoginFormField(
            placeholder: "Twitter Username",
            enabled: false,
            controller: twitterTextController,
            fillColor: !twitterSetup
                ? Colors.red.withOpacity(0.4)
                : twitterColor.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
