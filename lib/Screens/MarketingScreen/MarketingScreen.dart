import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:provider/provider.dart';

class MarketingScreen extends StatefulWidget {
  @override
  _MarketingScreenState createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  bool isLoading = false;
  String _lat = "";
  String _long = "";

  final _formKey = GlobalKey<FormState>();
  String _zoneValue = '1';
  String _oldOrNewValue = 'old';
  String _nawrasProduct = 'no';
  String _volumeValue = 'small';
  String _typeValue = 'plural';

  int salePersonId;

  String token;

  Map<String, dynamic> _textFiledData = {
    "token": "",
    "lat": 0,
    "lng": 0,
    "code": "",
    "zone_typies_id": "",
    "name": "mohammad mohammad",
    "market_name": "",
    "market_type": "large",
    "owner_name": "",
    "phone_number": "07501711438",
    "location": "",
    "opposite": "hawler",
    "near": "",
    "newold": "",
    "state": "",
    "reason": "x no x",
    "s_visit": "Raman Zana",
    "lead": "",
    "type": "",
    "size": "",
    "uploaded_file": "",
    "sale_person_id": 0,
  };

  _onSubmit() async {
    // if (!_formKey.currentState.validate()) return;
    _textFiledData['zone_typies_id'] = _zoneValue;
    _textFiledData['newold'] = _oldOrNewValue;
    _textFiledData['state'] = _nawrasProduct;
    _textFiledData['size'] = _volumeValue;
    _textFiledData['type'] = _typeValue;
    _textFiledData['uploaded_file'] = imageUrl;
    _textFiledData['lat'] = _lat;
    _textFiledData['lng'] = _long;
    _textFiledData['sale_person_id'] = salePersonId;
    _textFiledData['token'] = token;

    await Provider.of<OtherProvider>(context, listen: false)
        .sendRequestMarketTeam(data: _textFiledData)
        .then((value) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);
    });

    setState(() {
      isLoading = false;
    });
  }

  getService() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _long = _locationData.longitude.toString();
      _lat = _locationData.latitude.toString();
    });
  }

  File image;
  String imageUrl = "";
  final picker = ImagePicker();

  getImage() async {
    final pickedFile = await picker.getImage(
        source: Platform.isIOS ? ImageSource.gallery : ImageSource.camera);
    setState(() {
      image = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('marketingImage/${DateTime.now().toString()}');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = uploadTask.snapshot;
      taskSnapshot.ref.getDownloadURL().then(
        (value) {
          setState(() {
            imageUrl = value;
          });
          return value;
        },
      );
    } catch (error) {
      print(error);
    }
    print('$imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    salePersonId = auth.salePerson.id;
    token = auth.session.mainToken;
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["marketing-form"]),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["fill-out-feedback"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: words["code"] + ":",
                            ),
                            onChanged: (value) {
                              _textFiledData['code'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["zone"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          radioCustomZone(words["bronze"], '1'),
                          radioCustomZone(words["silver"], '2'),
                          radioCustomZone(words["gold"], '3'),
                          radioCustomZone(words["platinum"], '4'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["market-info"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: words["name-of-market"]),
                            onChanged: (value) {
                              _textFiledData['market_name'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["owner-name"]),
                            onChanged: (value) {
                              _textFiledData['owner_name'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["address"]),
                            onChanged: (value) {
                              _textFiledData['location'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["near"]),
                            onChanged: (value) {
                              _textFiledData['near'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["old-new"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          radioCustomOldAndNew("Old", 'old'),
                          radioCustomOldAndNew("New", 'new'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["do-have"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          radioCustomNawrasProdcut(words["yes"], 'yes'),
                          radioCustomNawrasProdcut(words["no"], 'no'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["if-do"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["expo"]),
                            onChanged: (value) {
                              _textFiledData['exploitation'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["barprsy-mushtaryat"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["barprs"]),
                            onChanged: (value) {
                              _textFiledData['lead'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Type",
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          radioCustomType(words["plural"], 'plural'),
                          radioCustomType(words["singular"], 'singular'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["volume"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          radioCustomVolume(words["small"], 'small'),
                          radioCustomVolume(words["medium"], 'medium'),
                          radioCustomVolume(words["large"], 'large'),
                          radioCustomVolume(words["mini-market"], 'miniMarket'),
                          radioCustomVolume(
                              words["super-market"], 'superMarket'),
                          radioCustomVolume(
                              words["hyper-market"], 'hyperMarket'),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["image"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                  height: 45,
                                  child: RoundedButton(
                                      title: words["upload-image"],
                                      onPressed: () async {
                                        await getImage();
                                      })),
                              SizedBox(
                                height: 10,
                              ),
                              image == null
                                  ? getAppIcons(
                                      asset: AppIcons.upload,
                                      size: 50,
                                      color: PaletteColors.darkRedColorApp)
                                  : Image.file(
                                      image,
                                      height: 150,
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            words["note"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.mainAppColor),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: words["add-note"]),
                            onChanged: (value) {
                              _textFiledData['addNotes'] = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'Is empty';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      child: RoundedButton(
                        title: words["submit"],
                        radius: 12,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Firebase.initializeApp();
                          await uploadImageToFirebase(context);
                          await getService();
                          _onSubmit();
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            isLoading ? LoadingIndicator() : Center()
          ],
        ),
      ),
    );
  }

  // RoundedButton(title: "Get Location Info",   onPressed: () async {
  //   await getService();
  //   print("lat:"+_lat +"   "+ "long:"+_long);
  // }),

  radioCustomZone(title, value) {
    return RadioListTile(
      groupValue: _zoneValue,
      title: Text(title),
      value: value,
      onChanged: (val) {
        setState(() {
          _zoneValue = val;
        });
      },
    );
  }

  radioCustomOldAndNew(title, value) {
    return RadioListTile(
      groupValue: _oldOrNewValue,
      title: Text(title),
      value: value,
      onChanged: (val) {
        setState(() {
          _oldOrNewValue = val;
        });
      },
    );
  }

  radioCustomNawrasProdcut(title, value) {
    return RadioListTile(
      groupValue: _nawrasProduct,
      title: Text(title),
      value: value,
      onChanged: (val) {
        setState(() {
          _nawrasProduct = val;
        });
      },
    );
  }

  radioCustomType(title, value) {
    return RadioListTile(
      groupValue: _typeValue,
      title: Text(title),
      value: value,
      onChanged: (val) {
        setState(() {
          _typeValue = val;
        });
      },
    );
  }

  radioCustomVolume(title, value) {
    return RadioListTile(
      groupValue: _volumeValue,
      title: Text(title),
      value: value,
      onChanged: (val) {
        setState(() {
          _volumeValue = val;
        });
      },
    );
  }

  detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: AppTextStyle.regularTitle18
                .copyWith(color: PaletteColors.blackAppColor),
          ),
        ],
      ),
    );
  }
}
