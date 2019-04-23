import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/signup/signup_main_bloc.dart';
import 'package:ikonfete/screens/signup/signup_profile_screen.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/widget/themes/theme.dart';

Widget signupMainScreen(BuildContext context) {
  return BlocProvider<SignupMainBloc>(
    bloc: SignupMainBloc(),
    child: SignupMainScreen(),
  );
}

class SignupMainScreen extends StatefulWidget {
  @override
  _SignupMainScreenState createState() {
    return new _SignupMainScreenState();
  }
}

class _SignupMainScreenState extends State<SignupMainScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final signupBloc = BlocProvider.of<SignupMainBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: BlocBuilder<SignupMainScreenEvent, SignupMainScreenState>(
        bloc: signupBloc,
        builder: (context, state) {
          if (state.result != null) {
            final result = state.result;
            if (result.success) {
              ScreenUtils.onWidgetDidBuild(() {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (ctx) => signupProfileScreen(ctx,
                        name: result.name,
                        email: result.email,
                        password: result.password),
                  ),
                );
              });
            } else {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text(result.error),
                  backgroundColor: errorColor,
                ));
              });
            }
          }

          return Center(
            child: Container(
              height: double.infinity,
              width: sw(275),
              constraints: BoxConstraints(maxWidth: sw(375)),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewInsets.top + 40.0,
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  OverlayBuilder(
                    child: Container(),
                    showOverlay: state.isLoading,
                    overlayBuilder: (context) => HudOverlay.getOverlay(),
                  ),
                  _buildTitleAndBackButton(context),
                  SizedBox(height: 20.0),
                  _buildIntroText(context),
                  SizedBox(height: 30.0),
                  BlocBuilder<AppEvent, AppState>(
                    bloc: appBloc,
                    builder: (context, state) {
                      return SignupForm(
                        isArtist: state.isArtist,
                        formKey: formKey,
                        onSwitchMode: (isArtist) {
                          appBloc.dispatch(SwitchMode(isArtist: isArtist));
                        },
                      );
                    },
                  ),
                  _buildPolicyText(context),
                  SizedBox(height: 10.0),
                  BlocBuilder<AppEvent, AppState>(
                    bloc: appBloc,
                    builder: (context, state) {
                      return _buildButtons(context, state);
                    },
                  ),
                  SizedBox(height: 40.0),
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
              "WELCOME",
              style: IkTheme.of(context).headline.copyWith(),
            ),
          ],
        ),
        Navigator.of(context).canPop()
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(CupertinoIcons.back, color: Color(0xFF181D28)),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget _buildIntroText(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);

    final tapHandler = TapGestureRecognizer();
//    tapHandler.onTap = () => Navigator.pushReplacementNamed(context, Routes.login);
    tapHandler.onTap = () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    };

    final signInText = TextSpan(
      text: " Sign in",
      recognizer: tapHandler,
      style: TextStyle(color: primaryColor),
    );

    final fanSignupIntroText = "Create an account to connect to\n"
        "your true favourite artist. Already have\n"
        "an account? "; // TODO: localize this text
    final artistSignupIntroText =
        "Create an account to connect to\nyour awesome superfans. Already have\nan account?";

    return BlocBuilder<AppEvent, AppState>(
      bloc: appBloc,
      builder: (context, state) {
        final signupIntroText =
            state.isArtist ? artistSignupIntroText : fanSignupIntroText;
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: IkTheme.of(context)
                .subhead3
                .copyWith(color: IkColors.lightGrey, height: 1.2),
            text: signupIntroText,
            children: <TextSpan>[
              signInText,
            ],
          ),
        );
      },
    );
  }

  Widget _buildPolicyText(BuildContext context) {
//    final webviewAppBar = (String title) => AppBar(
//          backgroundColor: Colors.white,
//          elevation: 3.0,
//          leading: IconButton(
//            iconSize: 15.0,
//            icon: Icon(
//              ThemifyIcons.close,
//              color: Color(0xFFAAAAAA),
//            ),
//            onPressed: () => Navigator.of(context).pop(),
//          ),
//          title: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                title,
//                style: TextStyle(
//                  fontSize: 18.0,
//                  color: Colors.black,
//                  fontWeight: FontWeight.w200,
//                ),
//              ),
//            ],
//          ),
//        );

    final privacyPolicyTapHandler = TapGestureRecognizer();
    privacyPolicyTapHandler.onTap = () {};
//    privacyPolicyTapHandler.onTap = () => Navigator.of(context).push(
//          CupertinoPageRoute(
//            builder: (_) => WebviewScaffold(
//                  url: "http://ikonfete.com/privacy-policy",
//                  appBar: webviewAppBar("Privacy Policy - Ikonfete"),
//                ),
//          ),
//        ); todo:

    final termsTapHandler = TapGestureRecognizer();
    termsTapHandler.onTap = () {};
//    termsTapHandler.onTap = () => Navigator.of(context).push(
//          CupertinoPageRoute(
//            builder: (_) => WebviewScaffold(
//                  url: "http://ikonfete.com/terms-of-use",
//                  appBar: webviewAppBar("Terms of Use - Ikonfete"),
//                ),
//          ),
//        );todo:

    // TODO: localize this text
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 12.0, color: Colors.black),
        text: "By submitting this form, you agree to our\n",
        children: <TextSpan>[
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(
              color: primaryColor,
            ),
            recognizer: privacyPolicyTapHandler,
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              color: primaryColor,
            ),
            recognizer: termsTapHandler,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, AppState state) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: sw(300),
              height: sf(30),
              child: SizedBox(),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: IkColors.dividerColor, blurRadius: sw(30))
              ]),
            ),
            SizedBox(
              width: mq.size.width,
              child: CupertinoButton(
                pressedOpacity: .7,
                minSize: sf(60),
                color: IkColors.primary,
                child: Text('REGISTER'),
                onPressed: () => _formSubmitted(context, state),
              ),
            ),
          ],
        ),
//        _buildButtonSeparator(context),
//        SizedBox(
//          width: mq.size.width,
//          child: Stack(
//            alignment: Alignment.bottomCenter,
//            children: <Widget>[
//              Container(
//                width: sw(300),
//                height: sf(30),
//                child: SizedBox(),
//                decoration: BoxDecoration(boxShadow: [
//                  BoxShadow(color: IkColors.dark.shade300, blurRadius: sw(30))
//                ]),
//              ),
//              CupertinoButton(
//                pressedOpacity: .7,
//                minSize: sf(60),
//                color: IkColors.white,
//                child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Container(
//                          decoration: BoxDecoration(
//                            shape: BoxShape.circle,
//                            color: facebookColor,
//                          ),
//                          width: sf(25),
//                          height: sf(25),
//                          child: Icon(
//                            ThemifyIcons.facebook,
//                            color: Colors.white,
//                            size: sf(15),
//                          )),
//                      SizedBox(
//                        width: sw(10),
//                      ),
//                      Text(
//                        'Facebook',
//                        style: IkTheme.of(context).button,
//                      ),
//                    ]),
//                onPressed: () => _doFacebookSignup(context, state),
//              ),
//            ],
//          ),
//        ),
      ],
    );
  }

  Widget _buildButtonSeparator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 1.0,
              color: IkColors.dividerColor,
              margin: EdgeInsets.only(left: 40.0, right: 20.0),
            ),
          ),
          Text("or"), // "or"
          Expanded(
            child: Container(
              height: 1.0,
              color: IkColors.dividerColor,
              margin: EdgeInsets.only(right: 40.0, left: 20.0),
            ),
          ),
        ],
      ),
    );
  }

  void _formSubmitted(BuildContext context, AppState appState) {
    final bloc = BlocProvider.of<SignupMainBloc>(context);
    bool valid = formKey.currentState.validate();
    if (valid) {
      formKey.currentState.save();
      bloc.dispatch(ValidateForm(isArtist: appState.isArtist));
    }
  }

  void _doFacebookSignup(BuildContext context, AppState appState) {
//    final signupBloc = BlocProvider.of<SignupBloc>(context);
//    signupBloc.dispatch(FacebookSignup(isArtist: appState.isArtist));// todo
  }
}

class SignupForm extends StatefulWidget {
  final bool isArtist;
  final GlobalKey<FormState> formKey;
  final Function(bool) onSwitchMode;

  SignupForm({
    @required this.formKey,
    @required this.isArtist,
    this.onSwitchMode,
  });

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  FocusNode nameFocusNode;
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final switchModeTapHandler = TapGestureRecognizer();
    switchModeTapHandler.onTap = () {
      widget.onSwitchMode(!widget.isArtist);
    };

    final bloc = BlocProvider.of<SignupMainBloc>(context);

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoginFormField(
            placeholder: "Name",
            focusNode: nameFocusNode,
            validator: FormFieldValidators.notEmpty("name"),
            onFieldSubmitted: (newVal) {
              nameFocusNode.unfocus();
              FocusScope.of(context).requestFocus(emailFocusNode);
            },
            onSaved: (String val) => bloc.dispatch(NameEntered(val.trim())),
          ),
          SizedBox(height: sh(20)),
          LoginFormField(
            placeholder: "Email",
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            validator: FormFieldValidators.isValidEmail(),
            onFieldSubmitted: (newVal) {
              emailFocusNode.unfocus();
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            onSaved: (val) => bloc.dispatch(EmailEntered(val.trim())),
          ),
          SizedBox(height: 20.0),
          LoginPasswordField(
            placeholder: "Password",
            focusNode: passwordFocusNode,
            textInputAction: TextInputAction.done,
            revealIcon: FontAwesome5Icons.eye,
            hideIcon: FontAwesome5Icons.eyeSlash,
            validator: FormFieldValidators.minLength("password", 6),
            onFieldSubmitted: (newVal) {
              passwordFocusNode.unfocus();
            },
            onSaved: (val) => bloc.dispatch(PasswordEntered(val.trim())),
          ),
          SizedBox(height: sh(10)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Container()),
              RichText(
                text: TextSpan(
                  recognizer: switchModeTapHandler,
                  style: IkTheme.of(context).smallHint.copyWith(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                  text: "Switch to ${widget.isArtist ? "Fan" : "Artist"} mode",
                ),
              ),
            ],
          ),
          SizedBox(height: sh(30)),
        ],
      ),
    );
  }
}
