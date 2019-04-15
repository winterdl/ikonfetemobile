import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ikonfete/colors.dart';
import 'package:ikonfete/icons.dart';
import 'package:ikonfete/utils/compressed_image_capture.dart';
import 'package:ikonfete/utils/strings.dart';
import 'package:ikonfete/widget/form_fields.dart';
import 'package:image_picker/image_picker.dart';

class UserSignupProfileForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String, File, Country) onSaved;
  final String pictureUrl;

  UserSignupProfileForm({
    @required this.formKey,
    @required this.onSaved,
    this.pictureUrl,
  });

  @override
  _UserSignupProfileFormState createState() => _UserSignupProfileFormState();
}

class _UserSignupProfileFormState extends State<UserSignupProfileForm> {
  bool _loadingPicture = false;
  File _displayPicture;
  Country _selectedCountry;
  String _username;
  String _pictureUrl;
  FocusNode usernameFocusNode;

  @override
  void initState() {
    super.initState();
    usernameFocusNode = FocusNode();
    _selectedCountry = CountryPickerUtils.getCountryByIsoCode("ng");
    _pictureUrl = widget.pictureUrl;
  }

  @override
  Widget build(BuildContext context) {
    final uploadImageHandler = TapGestureRecognizer();
    uploadImageHandler.onTap = () {
      _chooseDisplayPicture(ImageSource.gallery);
    };

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ProfilePictureChooser(
              onTap: () {
                _chooseDisplayPicture(ImageSource.camera);
              },
              image: _displayPicture,
              imageUrl: _pictureUrl,
              isLoadingImage: _loadingPicture,
            ),
            SizedBox(height: 10.0),
            Text("OR"),
            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(
                text: "Upload Image",
                style: TextStyle(
                  color: primaryColor,
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.underline,
                ),
                recognizer: uploadImageHandler,
              ),
            ),
            SizedBox(height: 40.0),
            LoginFormField(
              validator: FormFieldValidators.notEmpty("username"),
              focusNode: usernameFocusNode,
              placeholder: "Username",
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onSaved: (val) {
                _username = val.trim();
                widget.onSaved(_username, _displayPicture, _selectedCountry);
              },
              onFieldSubmitted: (val) {
                usernameFocusNode.unfocus();
              },
            ),
            SizedBox(height: 30.0),
            Text(
              "Select your country",
              style: TextStyle(fontSize: 14.0, color: Colors.black),
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
                      CountryPickerUtils.getDefaultFlagImage(_selectedCountry),
                      SizedBox(width: 8.0),
                      Flexible(child: Text(_selectedCountry.name)),
                      SizedBox(width: 8.0),
                      Text("(${_selectedCountry.isoCode})"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _chooseDisplayPicture(ImageSource imageSource) async {
    setState(() {
      _loadingPicture = true;
    });
    final im = await CompressedImageCapture().takePicture(context, imageSource);
    setState(() {
      _loadingPicture = false;
      _displayPicture = im;
    });
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
              onValuePicked: (Country country) => setState(() {
                    _selectedCountry = country;
                  }),
              itemBuilder: (Country country) {
                return Row(
                  children: <Widget>[
                    CountryPickerUtils.getDefaultFlagImage(country),
                    SizedBox(width: 8.0),
                    Flexible(child: Text(country.name)),
                    SizedBox(width: 8.0),
                    Text("(${country.isoCode})"),
                  ],
                );
              },
            ),
          ),
    );
  }
}

class ProfilePictureChooser extends StatelessWidget {
  final Function onTap;
  final File image;
  final bool isLoadingImage;
  final String imageUrl;

  ProfilePictureChooser({
    this.onTap,
    this.image,
    this.isLoadingImage,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: image != null
            ? BoxDecoration(
                color: primaryColor.withOpacity(0.4),
                shape: BoxShape.circle,
                image:
                    DecorationImage(image: FileImage(image), fit: BoxFit.cover),
              )
            : !StringUtils.isNullOrEmpty(imageUrl)
                ? BoxDecoration(
                    color: primaryColor.withOpacity(0.4),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  )
                : null,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: image == null && StringUtils.isNullOrEmpty(imageUrl)
                  ? ClipOval(
                      child: Icon(
                        FontAwesome5Icons.solidUser,
                        color: primaryColor.withOpacity(0.5),
                        size: 80.0,
                      ),
                    )
                  : Container(),
            ),
            Icon(
              LineAwesomeIcons.camera,
              color: Colors.white,
              size: 40.0,
            ),
            isLoadingImage
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor))
                : Container(),
          ],
        ),
      ),
    );
  }
}
