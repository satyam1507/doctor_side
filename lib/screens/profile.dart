import 'dart:io';

import 'package:doctor_side/models/cooler.dart';
import 'package:doctor_side/models/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'homepage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final storageRef = FirebaseStorage.instance.ref();

class ProfileInfo extends StatefulWidget {
  final Doctor user;
  ProfileInfo(this.user);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  File _image;
  String _uploadedFileUrl;
  final picker = ImagePicker();
  GlobalKey<FormState> _updateInfo = GlobalKey<FormState>();
  String name, phoneno, fee, detail, tag, email, pass, address;
  bool showPwd = false;

  @override
  void initState() {
    super.initState();
  }

  handleUpdate() async {
    if (_updateInfo.currentState.validate()) {
      _updateInfo.currentState.save();
      await userRef.doc(widget.user.uid).update({
        'name': name,
        'email': email,
        'pwd': pass,
        'address': address,
        'phoneno': phoneno,
        'fee': fee,
        'detail': detail,
        'tag': tag,
      });
      //  await auth.currentUser().then((value) => value.updatePassword(pass));
    }
  }

  handleRemove() async {
    await userRef.doc(widget.user.uid).update({'photoUrl': ""});
  }

  openCam() async {
    final pickedImg = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImg.path);
    });
    Reference ref = storageRef.child("dp_${widget.user.name}");
    final UploadTask storageUploadTask = ref.putFile(_image);

    await (await storageUploadTask).ref.getDownloadURL().then((fileURL) {
      userRef.doc(widget.user.uid).update({'photoUrl': fileURL});
    });
  }

  chooseFile() async {
    final pickedImg = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImg.path);
    });
    Reference ref = storageRef.child("dp_${widget.user.name}");
    UploadTask storageUploadTask = ref.putFile(_image);

    await (await storageUploadTask).ref.getDownloadURL().then((fileURL) {
      userRef.doc(widget.user.uid).update({'photoUrl': fileURL});
    });
  }

  updatePhoto() async {
    await userRef.doc(widget.user.uid).update({'photoUrl': _uploadedFileUrl});
  }

  handlePhoto() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select Photo from:"),
        content: Container(
          height: 125.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: greenish,
                onPressed: () {
                  openCam();
                },
                child: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              RaisedButton(
                color: greenish,
                onPressed: () {
                  chooseFile();
                },
                child: Text('Gallery',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Close",
            ),
          ),
        ],
      ),
    );
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userRef.doc(widget.user.uid).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                strokeWidth: 5.0,
              ),
            ),
          );
        }
        Doctor user = Doctor.fromDocument(snap.data);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: Text(
              user.name,
              style: TextStyle(
                color: greenish,
              ),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                    child: Stack(
                      alignment: Alignment(0, 0.7),
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(57, 90, 174, 1),
                          backgroundImage: snap.data['photoUrl'] == null
                              ? null
                              : NetworkImage(snap.data['photoUrl']),
                          radius: 70.0,
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.black45),
                          child: InkWell(
                            onTap: () {
                              handlePhoto();
                            },
                            child: Text(
                              "Update Photo",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _updateInfo,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => name = val,
                            initialValue: user.name,

                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Full Name",
                              hintText: "Full Name",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => phoneno = val,
                            initialValue: user.phoneno,
                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Phone Number",
                              hintText: "Phone Number",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => email = val,
                            initialValue: user.email,
                            validator: (value) => emailValidator(value),
                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Email",
                              hintText: "Email",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => address = val,
                            initialValue: user.address,
                            validator: (value) {
                              if (value.length < 5) {
                                return "Please enter a valid Address ";
                              }
                              return null;
                            },

                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Address",
                              hintText: "Address",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => tag = val,
                            initialValue: user.tag,
                            validator: (value) {
                              if (value.length < 5) {
                                return "Please enter a valid specialization  ";
                              }
                              return null;
                            },

                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "specialization ",
                              hintText: "specialization ",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => detail = val,
                            initialValue: user.detail,
                            validator: (value) {
                              if (value.length < 5) {
                                return "Please enter a valid detail";
                              }
                              return null;
                            },

                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "detail",
                              hintText: "detail",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            onSaved: (val) => fee = val,
                            initialValue: user.fee,
                            validator: (value) {
                              if (value.length < 2) {
                                return "Please enter a valid Fee ";
                              }
                              return null;
                            },

                            // autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Fee",
                              hintText: "Fee",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, bottom: 10),
                          child: TextFormField(
                            initialValue: user.pwd,
                            onSaved: (val) => pass = val,
                            obscureText: showPwd ? false : true,
                            validator: (value) => pwdValidator(value),
                            //  autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0)),
                              ),
                              labelText: "Password",
                              hintText: "Password",
                              suffix: GestureDetector(
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 20.0,
                                  color: greenish,
                                ),
                                onTap: () => setState(() {
                                  showPwd = !showPwd;
                                }),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: RaisedButton(
                          elevation: 0,
                          onPressed: () async {
                            await handleUpdate();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_circle_up,
                                color: greenish,
                              ),
                              Text(
                                'Update',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: greenish,
                                    fontSize: 10.0),
                              ),
                            ],
                          ),
                          color: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0),
                            side: BorderSide(color: greenish),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
