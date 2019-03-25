import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikonfete/app_bloc.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/screen_utils.dart';
import 'package:ikonfete/screens/reset_password/reset_password_bloc.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/hud_overlay.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';
import 'package:ikonfete/widget/overlays.dart';

Widget resetPasswordScreen(BuildContext context) {
  final appBloc = BlocProvider.of<AppBloc>(context);
  return BlocBuilder<AppEvent, AppState>(
    bloc: appBloc,
    builder: (ctx, appState) {
      return ResetPasswordScreen(
          bloc: ResetPasswordBloc(isArtist: appState.isArtist));
    },
  );
}

class ResetPasswordScreen extends StatefulWidget {
  final ResetPasswordBloc bloc;

  ResetPasswordScreen({@required this.bloc});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> codeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body: BlocBuilder<ResetPasswordScreenEvent, ResetPasswordState>(
        bloc: widget.bloc,
        builder: (ctx, resetPasswordState) {
          if (resetPasswordState.sendEmailResult != null) {
            final res = resetPasswordState.sendEmailResult;
            if (!res.first) {
              ScreenUtils.onWidgetDidBuild(() {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(res.second),
                  backgroundColor: errorColor,
                ));
              });
            } else {
              ScreenUtils.onWidgetDidBuild(() {
                _showSuccessDialog();
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
                  showOverlay: resetPasswordState.isLoading,
                  overlayBuilder: (context) => HudOverlay.getOverlay(),
                ),
                _buildTitleAndBackButton(context),
                SizedBox(height: 20.0),
                _buildIntroText(context, resetPasswordState),
                SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: EmailForm(resetPasswordState, emailFormKey,
                      (val) => widget.bloc.dispatch(EmailEntered(val))),
//                  child: AnimatedSwitcher(
//                    switchInCurve: Curves.easeIn,
//                    switchOutCurve: Curves.easeOut,
//                    duration: Duration(milliseconds: 800),
//                    child: _getForm(resetPasswordState),
//                    transitionBuilder: (child, animation) =>
//                        FadeTransition(opacity: animation, child: child),
//                  ),
                ),
                SizedBox(height: 20.0),
                _buildButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

//  Widget _getForm(ResetPasswordState resetPasswordState) {
//    switch (resetPasswordState.step) {
//      case ResetPasswordStep.EmailEntry:
//        return EmailForm(resetPasswordState, emailFormKey,
//            (val) => widget.bloc.dispatch(EmailEntered(val)));
//      case ResetPasswordStep.CodeEntry:
//        return CodeForm(resetPasswordState, codeFormKey,
//            (val) => widget.bloc.dispatch(CodeEntered(val)));
//      case ResetPasswordStep.PasswordEntry:
//        return Container(
//          child: Form(
//            key: passwordFormKey,
//            child: Container(),
//          ),
//        );
//      default:
//        return Container();
//    }
//  }

  Widget _buildTitleAndBackButton(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "RESET PASSWORD",
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

  Widget _buildIntroText(BuildContext context, ResetPasswordState state) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        text: "Enter the email you signed up with",
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
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
          text: "NEXT",
          // REGISTER
          onTap: () {
            if (emailFormKey.currentState.validate()) {
              emailFormKey.currentState.save();
              widget.bloc.dispatch(GetResetLink());
            }
          },
        ),
      ],
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text("Email Sent"),
            content: Text(
                "A password reset link has been sent to your email address"),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"), onPressed: () => Navigator.pop(ctx, true)),
            ],
          ),
    );
    Navigator.of(context).pop();
  }
}

class EmailForm extends StatelessWidget {
  final ResetPasswordState state;
  final GlobalKey<FormState> formKey;
  final Function(String) onSaved;
  final FocusNode emailFocusNode = FocusNode();

  EmailForm(this.state, this.formKey, this.onSaved);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: LoginFormField(
        placeholder: "Email",
        focusNode: emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        validator: FormFieldValidators.isValidEmail(),
        onFieldSubmitted: (newVal) => emailFocusNode.unfocus(),
        onSaved: (val) => onSaved(val),
      ),
    );
  }
}
