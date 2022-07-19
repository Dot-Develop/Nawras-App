import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/Screens/MapScreen/Widgets/shopMapCard.dart';

class MapScreen extends StatefulWidget {
  final dynamic shops;
  final dynamic currentShop;
  final LatLng salePersonLocation;

  const MapScreen({
    Key key,
    this.shops,
    this.currentShop,
    this.salePersonLocation,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // Completer<GoogleMapController> _controller = Completer();
  List<Marker> _marker = [];
  BitmapDescriptor mapMarker;
  bool _getLocationLoading = false;
  LatLng _currentShopLocation;
  GoogleMapController _controller;
  int marketId;

  @override
  void initState() {
    super.initState();
    _currentShopLocation = LatLng(double.parse(widget.currentShop.lat),
        double.parse(widget.currentShop.lng));
    marketId = widget.currentShop.id;
    setCustomMarker();
  }

  void setCustomMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/anims/mapsgop.png', 120);
    mapMarker = BitmapDescriptor.fromBytes(markerIcon);
    // mapMarker =
    //     await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(110, 110),devicePixelRatio: 0.6,), 'assets/anims/rsz_shop-map.png');
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    _controller = controller;
    controller.setMapStyle(Utils.mapStyle);
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId('12'),
          position: widget.salePersonLocation,
          infoWindow: InfoWindow(title: 'Marekt zanko'),
          // icon: mapMarker
        ),
      );
      _marker.add(
        Marker(
            markerId: MarkerId('123'),
            position: _currentShopLocation,
            infoWindow: InfoWindow(title: 'Marekt zanko'),
            icon: mapMarker),
      );
      // widget.shops.forEach((shop) {
      //   _marker.add(
      //     Marker(
      //       markerId: MarkerId(shop.id.toString()),
      //       position: LatLng(
      //         double.parse(shop.lat),
      //         double.parse(shop.lng),
      //       ),
      //       infoWindow: InfoWindow(title: shop.name),
      //       icon: mapMarker,
      //     ),
      //   );
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Direction(
      child: Scaffold(
        key: _drawerKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: PaletteColors.whiteBg,
          child: Icon(
            Icons.my_location,
            color: PaletteColors.redColorApp,
          ),
          onPressed: () {
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: widget.salePersonLocation,
                  zoom: 15.0,
                  // bearing: 45.0,
                  // tilt: 45.0,
                ),
              ),
            );
          },
        ),
        body: _getLocationLoading
            ? LoadingIndicator()
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _currentShopLocation,
                      zoom: 15.0,
                      // bearing: 45.0,
                      // tilt: 45.0,
                    ),
                    markers: Set.from(_marker),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                    child: ListTile(
                      // title: Text(words["map"]),
                      leading: CircleAvatar(
                        backgroundColor: PaletteColors.redColorApp,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: PaletteColors.redColorApp,
                        child: IconButton(
                          icon: getAppIcons(
                            asset: AppIcons.market,
                            size: 30,
                          ),
                          onPressed: () => _drawerKey.currentState.openDrawer(),
                        ),
                      ),
                    ),
                  )
                ],
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
                    color: marketId == widget.shops[index].id
                        ? PaletteColors.redColorApp
                        : PaletteColors.whiteBg,
                    title: widget.shops[index].name,
                    onPressed: () {
                      setState(() {
                        _marker.removeLast();
                        _marker.add(
                          Marker(
                            markerId: MarkerId('123'),
                            position: LatLng(
                              double.parse(widget.shops[index].lat),
                              double.parse(widget.shops[index].lng),
                            ),
                            infoWindow: InfoWindow(title: 'Marekt zanko'),
                            icon: mapMarker,
                          ),
                        );
                        marketId = widget.shops[index].id;
                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                double.parse(widget.shops[index].lat),
                                double.parse(widget.shops[index].lng),
                              ),
                              zoom: 15.0,
                              // bearing: 45.0,
                              // tilt: 45.0,
                            ),
                          ),
                        );
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Utils {
  static String mapStyle = '''
  [
  {
    "featureType": "poi.business",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
]
  ''';
}
