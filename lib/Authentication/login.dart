import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTaxteEdtingController =
      TextEditingController();
  final TextEditingController _passwordTaxteEdtingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset("images/login.png"),
              height: 240,
              width: 240,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Login To your Account",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
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
                      hintText: "password",
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    _emailTaxteEdtingController.text.isNotEmpty &&
                            _passwordTaxteEdtingController.text.isNotEmpty
                        ? loginUser()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: "Please Write email and password",
                              );
                            });
                  },
                  child: Text(
                    "Login",
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
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: (Icon(
                Icons.nature_people,
                color: Colors.white,
              )),
              label: Text(
                "I am Admin",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: " Registrting, please wait.....",
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTaxteEdtingController.text.trim(),
            password: _passwordTaxteEdtingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
