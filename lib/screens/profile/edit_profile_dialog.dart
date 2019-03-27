import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/screens/profile/profile_picture_chooser.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:ikonfete/widget/ikonfete_buttons.dart';

class EditProfileDialog extends ModalRoute<EditProfileInfoResult> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.white;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  final String profilePictureUrl;
  final String username;
  final String name;
  final String countryCode;
  final String countryName;

  EditProfileDialog(
      {@required this.username,
      @required this.name,
      @required this.countryCode,
      @required this.countryName,
      @required this.profilePictureUrl});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: EditProfileInfoScreen(
          profilePictureUrl: profilePictureUrl,
          countryCode: countryCode,
          countryName: countryName,
          name: name,
          username: username,
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class EditProfileInfoResult {
  final File profilePicture;
  final String displayName;
  final String countryIsoCode;
  final String country;

  EditProfileInfoResult({
    this.profilePicture,
    this.displayName,
    this.countryIsoCode,
    this.country,
  });
}

class EditProfileInfoScreen extends StatefulWidget {
  final String profilePictureUrl;
  final String username;
  final String name;
  final String countryCode;
  final String countryName;

  EditProfileInfoScreen({
    @required this.profilePictureUrl,
    @required this.username,
    @required this.name,
    @required this.countryCode,
    @required this.countryName,
  });

  @override
  _EditProfileInfoScreenState createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen> {
  TextEditingController _displayNameController;
  File _selectedImage;
  Country _selectedDialogCountry;
  String _newDisplayName;

  @override
  void initState() {
    super.initState();
    _selectedDialogCountry =
        CountryPickerUtils.getCountryByIsoCode(widget.countryCode);

    _displayNameController = TextEditingController(text: widget.name);
    _displayNameController.addListener(() {
      setState(() {
        _newDisplayName = _displayNameController.text;
      });
    });
  }

  bool _changesMade() {
    return (!StringUtils.isNullOrEmpty(_newDisplayName) &&
            _newDisplayName != widget.name) ||
        _selectedImage != null ||
        (_selectedDialogCountry != null &&
            widget.countryCode.toLowerCase() !=
                _selectedDialogCountry.isoCode.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          color: Colors.black54,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Edit Profile Info",
          style: TextStyle(fontSize: 20.0, color: Colors.black45),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(LineAwesomeIcons.check),
            color: Colors.black54,
            onPressed: _changesMade() ? _saveChanges : null,
            tooltip: "Done",
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Click on the image below to update your profile picture",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            ProfilePictureChooser(
              onImageSelected: (File image) {
                setState(() => _selectedImage = image);
              },
              imageUrl: widget.profilePictureUrl,
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Display Name",
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: LoginFormField(
                controller: _displayNameController,
                textAlign: TextAlign.center,
                onSaved: (val) {
                  setState(() {
                    _newDisplayName = val;
                  });
                },
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Select Country",
                  style: TextStyle(color: Colors.black54, fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Material(
              child: InkWell(
                onTap: _showCountryPickerDialog,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _selectedDialogCountry == null
                          ? Container()
                          : CountryPickerUtils.getDefaultFlagImage(
                              _selectedDialogCountry),
                      SizedBox(width: 8.0),
                      Flexible(child: Text(_selectedDialogCountry?.name ?? "")),
                      SizedBox(width: 8.0),
                      Text("(${_selectedDialogCountry?.isoCode ?? ""})"),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            PrimaryButton(
              width: MediaQuery.of(context).size.width - 40.0,
              height: 50.0,
              defaultColor: primaryButtonColor,
              activeColor: primaryButtonActiveColor,
              text: "Done",
              disabled: !_changesMade(),
              onTap: _saveChanges,
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }

  void _showCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text('Select your phone code'),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedDialogCountry = country;
                });
              },
              itemBuilder: _buildDialogItem,
            ),
          ),
    );
  }

  Widget _buildDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name)),
        SizedBox(width: 8.0),
        Text("(${country.isoCode})"),
      ],
    );
  }

  void _saveChanges() {
    Navigator.of(context).pop(EditProfileInfoResult(
      displayName: _newDisplayName,
      countryIsoCode: _selectedDialogCountry.isoCode,
      country: _selectedDialogCountry.name,
      profilePicture: _selectedImage,
    ));
  }
}
