import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/routes.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/login/login_bloc.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';

Widget loginScreen(BuildContext context) {
  return BlocProvider<LoginBloc>(
    bloc: LoginBloc(),
    child: LoginScreen(),
  );
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body: BlocBuilder<AppEvent, AppState>(
        bloc: appBloc,
        builder: (context, appState) {
          return BlocBuilder<LoginEvent, LoginState>(
            bloc: loginBloc,
            builder: (BuildContext ctx, LoginState loginState) {
              if (loginState.emailAuthResult != null) {
                final result = loginState.emailAuthResult;
                if (result.success) {
                  final currentUser = result.currentUserHolder;
                  appBloc.dispatch(LoadCurrentUser());
                  final newScreen =
                      Routes.getHomePage(context, appBloc, currentUser, true);
                  ScreenUtils.onWidgetDidBuild(() {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (ctx) => newScreen));
                  });
                } else {
                  ScreenUtils.onWidgetDidBuild(() {
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(result.error),
                        backgroundColor: errorColor,
                      ),
                    );
                  });
                }
              }

              return Container(
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
                      showOverlay: loginState.isLoading,
                      overlayBuilder: (context) => HudOverlay.getOverlay(),
                    ),
                    _buildTitleAndBackButton(context),
                    SizedBox(height: 20.0),
                    _buildIntroText(context),
                    SizedBox(height: 30.0),
                    LoginForm(
                      formKey: formKey,
                      isArtist: appState.isArtist,
                      onSwitchMode: (isArtist) {
                        appBloc.dispatch(SwitchMode(isArtist: isArtist));
                      },
                    ),
                    Expanded(child: Container()),
                    _buildButtons(context, appState),
                    SizedBox(height: 40.0),
                  ],
                ),
              );
            },
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
              "LOGIN",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100),
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
    final tapHandler = TapGestureRecognizer();
    tapHandler.onTap =
        () => Navigator.pushReplacementNamed(context, Routes.signup);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        text:
            "Welcome back...or welcome for the first\ntime. Either way, get in here!:)\n"
            "Don't have an account yet? ",
        children: <TextSpan>[
          TextSpan(
            text: "Sign Up",
            recognizer: tapHandler,
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, AppState appState) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
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
          text: "LOGIN",
          onTap: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              loginBloc.dispatch(EmailLogin(isArtist: appState.isArtist));
            }
          },
        ),
        _buildButtonSeparator(context),
        PrimaryButton(
          width: screenSize.width - 80,
          height: 50.0,
          defaultColor: Colors.white,
          activeColor: Colors.white70,
          elevation: 3.0,
          onTap: () => loginBloc
              .dispatch(FacebookLoginEvent(isArtist: appState.isArtist)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: facebookColor,
                  ),
                  width: 25.0,
                  height: 25.0,
                  child: Icon(
                    ThemifyIcons.facebook,
                    color: Colors.white,
                    size: 15.0,
                  )),
              SizedBox(width: 10.0),
              Text("Facebook", style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonSeparator(BuildContext context) {
    final dividerColor = Color(0xFF707070);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 1.0,
              color: dividerColor,
              margin: EdgeInsets.only(left: 40.0, right: 20.0),
            ),
          ),
          Text("or"), // "or"
          Expanded(
            child: Container(
              height: 1.0,
              color: dividerColor,
              margin: EdgeInsets.only(right: 40.0, left: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isArtist;
  final Function(bool) onSwitchMode;

  LoginForm(
      {@required this.formKey, @required this.isArtist, this.onSwitchMode});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    final forgotPasswordTapHandler = TapGestureRecognizer();
    forgotPasswordTapHandler.onTap =
        () => Navigator.of(context).pushNamed(Routes.resetPassword);

    final switchModeTapHandler = TapGestureRecognizer();
    switchModeTapHandler.onTap = () {
      widget.onSwitchMode(!widget.isArtist);
    };

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LoginFormField(
              placeholder: "Email",
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              validator: FormFieldValidators.isValidEmail(),
              onFieldSubmitted: (newVal) {
                emailFocusNode.unfocus();
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              onSaved: (String val) =>
                  loginBloc.dispatch(EmailEntered(val.trim())),
            ),
            SizedBox(height: 20.0),
            LoginPasswordField(
              placeholder: "Password",
              focusNode: passwordFocusNode,
              textInputAction: TextInputAction.done,
              revealIcon: FontAwesome5Icons.eyeSlash,
              hideIcon: FontAwesome5Icons.eye,
              validator: FormFieldValidators.minLength("password", 6),
              onFieldSubmitted: (newVal) {
                passwordFocusNode.unfocus();
              },
              onSaved: (val) => loginBloc.dispatch(PasswordEntered(val)),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    recognizer: forgotPasswordTapHandler,
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.0,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                    text: "Forgotten Password?",
                  ),
                ),
                Expanded(child: Container()),
                RichText(
                  text: TextSpan(
                    recognizer: switchModeTapHandler,
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12.0,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                    text:
                        "Switch to ${widget.isArtist ? "Fan" : "Artist"} mode",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
