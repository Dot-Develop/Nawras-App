import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Screens/MapScreen/Widgets/shopMapCard.dart';

class MapIOSScreen extends StatefulWidget {
  final dynamic shops;
  final dynamic currentShop;
  final LatLng salePersonLocation;

  // final String lat;
  // final String lng;

  // final LatLng salePersonLocation;

  MapIOSScreen({this.shops, this.currentShop, this.salePersonLocation});

  @override
  _MapIOSScreenState createState() => _MapIOSScreenState();
}

class _MapIOSScreenState extends State<MapIOSScreen> {
  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  AppleMapController mapController;
  Map<AnnotationId, Annotation> annotations = <AnnotationId, Annotation>{};
  AnnotationId selectedAnnotation;
  LatLng _currentShopLocation;
  int _marketId;
  // List<Annotation> _annotations = [];
  BitmapDescriptor _annotationIcon;

  @override
  void initState() {
    _marketId = widget.currentShop.id;
    _currentShopLocation = LatLng(double.parse(widget.currentShop.lat),
        double.parse(widget.currentShop.lng));

    super.initState();
  }

  Set<Annotation> _createAnnotation() {
    List<Annotation> listA = [];
    for (int i = 0; i <= widget.shops.length; i++) {
      listA.add(Annotation(
        annotationId: AnnotationId("market$i"),
        anchor: Offset(0.5, -4),
        position: LatLng(double.parse(widget.shops[i].lat),
            double.parse(widget.shops[i].lng)),
        icon: _annotationIcon,
      ));
    }

    return <Annotation>[
      Annotation(
        annotationId: AnnotationId("sale-person"),
        anchor: Offset(0.5, -4),
        position: widget.salePersonLocation,
        icon: _annotationIcon,
      ),
    ].toSet();
  }

  Future<void> _createAnnotationImageFromAsset(BuildContext context) async {
    if (_annotationIcon == null) {
      final ImageConfiguration imageConfiguration =
          new ImageConfiguration(devicePixelRatio: 1.0);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/test_marker.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _annotationIcon = bitmap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              _drawerKey.currentState.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: getAppIcons(asset: AppIcons.market),
            )),
        title: Text(
          'Map',
          style: AppTextStyle.boldTitle20,
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PaletteColors.whiteBg,
        child: Icon(
          Icons.my_location,
          color: PaletteColors.redColorApp,
        ),
        onPressed: () {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                heading: 270.0,
                target: widget.salePersonLocation,
                pitch: 30.0,
                zoom: 15,
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              title: Text(
                'Market List',
                style: AppTextStyle.boldTitle16,
              ),
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: widget.shops.length,
                itemBuilder: (context, index) => ShopMapCard(
                  color: _marketId == widget.shops[index].id
                      ? PaletteColors.redColorApp
                      : PaletteColors.whiteBg,
                  title: widget.shops[index].name,
                  onPressed: () {
                    setState(() {
                      // _marker.removeLast();

                      _marketId = widget.shops[index].id;

                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            heading: 270.0,
                            target: LatLng(
                              double.parse(widget.shops[index].lat),
                              double.parse(widget.shops[index].lng),
                            ),
                            zoom: 13,
                            pitch: 30,
                          ),
                        ),
                      );
                      // _animatedMapMove(
                      //     LatLng(
                      //       double.parse(widget.shops[index].lat),
                      //       double.parse(widget.shops[index].lng),
                      //     ),
                      //     14.0);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: AppleMap(
                    onMapCreated: _onMapCreated,
                    annotations: _createAnnotation(),
                    initialCameraPosition: CameraPosition(
                      zoom: 13,
                      pitch: 30,
                      heading: 270.0,
                      target: widget.salePersonLocation,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 15,
            bottom: 25,
            child: Container(
              height: 100,
              width: 40,
              decoration: BoxDecoration(
                  color: PaletteColors.whiteBg,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: PaletteColors.darkRedColorApp,
                    ),
                    onPressed: () {
                      mapController.moveCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.minimize,
                      color: PaletteColors.darkRedColorApp,
                    ),
                    onPressed: () {
                      mapController.moveCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
