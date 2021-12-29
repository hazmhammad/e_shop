import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTaxteEdtingController =
      TextEditingController();
  final TextEditingController _emailTaxteEdtingController =
      TextEditingController();
  final TextEditingController _passwordTaxteEdtingController =
      TextEditingController();
  String userImageUrl = "";
  File _imageFile;
  final TextEditingController _cpasswordTaxteEdtingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    // _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * .15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * .15,
                        color: Colors.blueGrey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameTaxteEdtingController,
                      data: Icons.person,
                      isObsecure: false,
                      hintText: "name",
                    ),
                    CustomTextField(
                      controller: _emailTaxteEdtingController,
                      data: Icons.email,
                      isObsecure: false,
                      hintText: "email",
                    ),
                    CustomTextField(
                      controller: _passwordTaxteEdtingController,
                      data: Icons.person,
                      isObsecure: true,
                      hintText: "passwprd",
                    ),
                    CustomTextField(
                      controller: _cpasswordTaxteEdtingController,
                      data: Icons.person,
                      isObsecure: true,
                      hintText: "Cpasswped",
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    uploadAndSaveImage();
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 4,
              width: _screenWidth * .8,
              color: Colors.white,
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: "please Select an image file");
          });
    } else {
      _passwordTaxteEdtingController.text ==
              _cpasswordTaxteEdtingController.text
          ? _emailTaxteEdtingController.text.isNotEmpty &&
                  _nameTaxteEdtingController.text.isNotEmpty &&
                  _passwordTaxteEdtingController.text.isNotEmpty &&
                  _cpasswordTaxteEdtingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialoge("Please fill up the regestrtion complete form")
          : displayDialoge("Password do not match");
    }
  }

  displayDialoge(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, Please wait.....',
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storagereference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storagereference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTaxteEdtingController.text.trim(),
      password: _passwordTaxteEdtingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection("user").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTaxteEdtingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["grabageValue"]
    });
    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTaxteEdtingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["grabageValue"]);
  }
}
