//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.black87, Colors.blue],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(
          "e-shop",
          style: TextStyle(
              color: Colors.white, fontSize: 55.0, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIdEdtingController =
      TextEditingController();
  final TextEditingController _passwordEdtingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    // _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          colors: [Colors.black87, Colors.blue],
          //begin: const FractionalOffset(0.0, 0.0),
          //end: const FractionalOffset(0.0, 0.0),
          tileMode: TileMode.clamp,
          stops: [0.0, 1.0],
        )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset("images/admin.png"),
              height: 250,
              width: 250,
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                "Admin",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIdEdtingController,
                      data: Icons.person,
                      isObsecure: false,
                      hintText: "Id",
                    ),
                    CustomTextField(
                      controller: _passwordEdtingController,
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
                    _adminIdEdtingController.text.isNotEmpty &&
                            _passwordEdtingController.text.isNotEmpty
                        ? loginAdmin()
                        : showDialog(
                            context: context,
                            builder: (c) {
                              return ErrorAlertDialog(
                                message: "Please Write email and password",
                              );
                            });
                  },
                  child: Text(
                    "Login Admin",
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
              height: 20,
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: (Icon(
                Icons.nature_people,
                color: Colors.white,
              )),
              label: Text(
                "I am Not Admin",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection("Admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((reslut) {
        if (reslut.data["id"] != _adminIdEdtingController.text.trim()) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("your id is not correct")));
        } else if (reslut.data["password"] !=
            _passwordEdtingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("your password not correct")));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Weclcom Dear Admin" + reslut.data["name"])));

          setState(() {
            _adminIdEdtingController.text = "";
            _passwordEdtingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
