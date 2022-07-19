import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Screens/MapScreen/Widgets/shopMapCard.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:provider/provider.dart';

class AndroidMapScreen extends StatefulWidget {
  final dynamic shops;
  final dynamic currentShop;
  final LatLng salePersonLocation;

  const AndroidMapScreen({
    Key key,
    @required this.shops,
    @required this.currentShop,
    @required this.salePersonLocation,
  }) : super(key: key);

  @override
  _AndroidMapScreenState createState() => _AndroidMapScreenState();
}

class _AndroidMapScreenState extends State<AndroidMapScreen>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  MapController _mapController = MapController();
  LatLng _currentShopLocation;
  int _marketId;
  List<Marker> _marker = [];

  @override
  void initState() {
    _marketId = widget.currentShop.id;
    _currentShopLocation = LatLng(double.parse(widget.currentShop.lat),
        double.parse(widget.currentShop.lng));
    _marker.add(
      Marker(
        width: 60.0,
        height: 60.0,
        point: widget.salePersonLocation,
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red[600],
          size: 28,
        ),
      ),
    );
    _marker.add(
      Marker(
        width: 40.0,
        height: 40.0,
        point: _currentShopLocation,
        builder: (ctx) => Image.asset(
          'assets/anims/mapsgop.png',
          width: 40,
          height: 40,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageDirection = Provider.of<Language>(context).languageDirection;
    return Scaffold(
      key: _drawerKey,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentShopLocation,
              zoom: 14.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mohammadhassan/ckcu8a4y53j3w1iqhtet1j6ej/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibW9oYW1tYWRoYXNzYW4iLCJhIjoiY2syNG9lbHV6MWM1ODNsbnl2aWRtbWI4YSJ9._WxnyAnmX3YzppS70ZeEjw",
                // urlTemplate:
                //     "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                // subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: _marker,
              ),
              // CircleLayerOptions(circles: [
              //   CircleMarker(
              //     //radius marker
              //     point: widget.salePersonLocation,
              //     color: Colors.blue.withOpacity(0.3),
              //     borderStrokeWidth: 3.0,
              //     borderColor: Colors.blue,
              //     radius: 60,
              //   )
              // ]),
            ],
          ),
          Align(
            alignment: Alignment(languageDirection == 'ltr' ? 0.9 : -0.9, 0.95),
            child: Material(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(25),
              elevation: 2,
              child: IconButton(
                  icon: Icon(Icons.my_location),
                  onPressed: () {
                    _animatedMapMove(widget.salePersonLocation, 14.0);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: PaletteColors.redColorApp,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
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
                  color: _marketId == widget.shops[index].id
                      ? PaletteColors.redColorApp
                      : PaletteColors.whiteBg,
                  title: widget.shops[index].name,
                  onPressed: () {
                    setState(() {
                      _marker.removeLast();
                      _marker.add(
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(
                            double.parse(widget.shops[index].lat),
                            double.parse(widget.shops[index].lng),
                          ),
                          builder: (ctx) => Image.asset(
                            'assets/anims/mapsgop.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      );
                      _marketId = widget.shops[index].id;
                      _animatedMapMove(
                          LatLng(
                            double.parse(widget.shops[index].lat),
                            double.parse(widget.shops[index].lng),
                          ),
                          14.0);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // take to your location
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
