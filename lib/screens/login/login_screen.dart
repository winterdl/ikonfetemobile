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
import 'package:ikonfete/widget/overlays.dart';
import 'package:ikonfete/widget/themes/theme.dart';

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
      resizeToAvoidBottomPadding: true,
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

              return Center(
                child: Container(
                  height: double.infinity,
                  width: sw(275),
                  constraints: BoxConstraints(maxWidth: sw(375)),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewInsets.top + 40.0,
                  ),
                  child: ListView(
                    reverse: false,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      OverlayBuilder(
                        child: Container(),
                        showOverlay: loginState.isLoading,
                        overlayBuilder: (context) => HudOverlay.getOverlay(),
                      ),
                      _buildTitleAndBackButton(context),
                      SizedBox(height: sh(20)),
                      _buildIntroText(context),
                      SizedBox(height: sh(30)),
                      LoginForm(
                        formKey: formKey,
                        isArtist: appState.isArtist,
                        onSwitchMode: (isArtist) {
                          appBloc.dispatch(SwitchMode(isArtist: isArtist));
                        },
                      ),
                      // const Spacer(),
                      _buildButtons(context, appState),
                      SizedBox(height: sh(40)),
                    ],
                  ),
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
    final tapHandler = TapGestureRecognizer();
    tapHandler.onTap =
        () => Navigator.pushReplacementNamed(context, Routes.signup);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: IkTheme.of(context)
            .subhead3
            .copyWith(color: IkColors.lightGrey, height: 1.2),
        text:
            "Welcome back...or welcome for the first time. Either way, get in here!:)"
            "Don't have an account yet?  ",
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
                child: Text('LOGIN'),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    formKey.currentState.save();
                    loginBloc.dispatch(EmailLogin(isArtist: appState.isArtist));
                  }
                },
              ),
            ),
          ],
        ),
        _buildButtonSeparator(context),
        SizedBox(
          width: mq.size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: sw(300),
                height: sf(30),
                child: SizedBox(),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(color: IkColors.dark.shade300, blurRadius: sw(30))
                ]),
              ),
              CupertinoButton(
                pressedOpacity: .7,
                minSize: sf(60),
                color: IkColors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: facebookColor,
                          ),
                          width: sf(25),
                          height: sf(25),
                          child: Icon(
                            ThemifyIcons.facebook,
                            color: Colors.white,
                            size: sf(15),
                          )),
                      SizedBox(
                        width: sw(10),
                      ),
                      Text(
                        'Facebook',
                        style: IkTheme.of(context).button,
                      ),
                    ]),
                onPressed: () => loginBloc
                    .dispatch(FacebookLoginEvent(isArtist: appState.isArtist)),
              ),
            ],
          ),
        ),
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
          SizedBox(height: sh(20)),
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
          SizedBox(height: sh(20)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  recognizer: forgotPasswordTapHandler,
                  style: IkTheme.of(context).smallHint,
                  text: "Forgotten Password?",
                ),
              ),
              Expanded(child: Container()),
              RichText(
                text: TextSpan(
                  recognizer: switchModeTapHandler,
                  style: IkTheme.of(context).smallHint,
                  text: "Switch to ${widget.isArtist ? "Fan" : "Artist"} mode",
                ),
              ),
            ],
          ),
          SizedBox(height: sh(60)),
        ],
      ),
    );
  }
}
