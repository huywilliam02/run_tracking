import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:polyline_do/polyline_do.dart' as polydo;

import '../../../tracking_map_v2/model/data_model_strava.dart';

class ReDrawMap extends StatefulWidget {
  ReDrawMap({
    super.key,
    required this.dataModel,
  });
  final DataModelStrava dataModel;
  // final TrackingResultController resultController;

  @override
  State<ReDrawMap> createState() => _ReDrawMapState();
}

class _ReDrawMapState extends State<ReDrawMap> {
  DataModelStrava? dataModel;
  late LatLng centerLatLng;
  late GoogleMapController controllerGm;
  List<LatLng> polylines = [];
  String totalKm = "";
  double totalKmNum = 0;
  Set<Marker> markers = Set<Marker>();
  late List<List<double>> listPolyline;
  late Timer timer;
  bool err = false;

  @override
  void initState() {
    super.initState();
    try {
      dataModel = widget.dataModel;
      polydo.Polyline polyline = polydo.Polyline.Decode(
          encodedString: dataModel!.map.polyline, precision: 5);
      listPolyline = polyline.decodedCoords;
      var count = 0;
      var index = (listPolyline.length / 2).round();
      centerLatLng = LatLng(listPolyline[index][0], listPolyline[index][1]);
      setState(() {
        addMarkerStart(LatLng(listPolyline[count][0], listPolyline[count][1]));
        addMarkerEnd(LatLng(listPolyline.last[0], listPolyline.last[1]));
      });
      timer = Timer.periodic(Duration(microseconds: 500), (timer) {
        if (this.mounted) {
          setState(() {
            if (count < listPolyline.length - 1) {
              polylines
                  .add(LatLng(listPolyline[count][0], listPolyline[count][1]));
              totalKmNum = totalKmNum +
                  Geolocator.distanceBetween(
                      listPolyline[count][0],
                      listPolyline[count][1],
                      listPolyline[count + 1][0],
                      listPolyline[count + 1][1]);
              totalKm = totalKmNum.toStringAsPrecision(2).toString();

              count++;
            } else {
              polylines.add(LatLng(listPolyline.last[0], listPolyline.last[1]));
              timer.cancel();
            }
          });
        }
      });
     Future.delayed(Duration(seconds: 3), () async {
        LatLngBounds latLngBounds;
        LatLng first = LatLng(listPolyline.first[0], listPolyline.first[1]);
        LatLng end = LatLng(listPolyline.last[0], listPolyline.last[1]);
        if (first.latitude > end.latitude && first.longitude > end.longitude) {
          latLngBounds = LatLngBounds(southwest: end, northeast: first);
        } else if (first.longitude > end.longitude) {
          latLngBounds = LatLngBounds(
              southwest: LatLng(first.latitude, end.longitude),
              northeast: LatLng(end.latitude, first.longitude));
        } else if (first.latitude > end.latitude) {
          latLngBounds = LatLngBounds(
              southwest: LatLng(end.latitude, first.longitude),
              northeast: LatLng(first.latitude, end.longitude));
        } else {
          latLngBounds = LatLngBounds(southwest: first, northeast: end);
        }

        setState(() {
          try {
            controllerGm
                .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
          } catch (e) {
            print(e);
          }
        });
      });
    } catch (e) {
      setState(() {
        err = true;
      });
    }
  }

  @override
  void dispose() {
    if (!err) {
      timer.cancel();
      controllerGm.dispose();
    }
    super.dispose();
  }

  addMarkerStart(LatLng position) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/ic_map_pin_purple.png', 50);
    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId('1'),
        position: position);
    markers.add(marker);
  }

  addMarkerEnd(LatLng position) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/ic_map_pin_red.png', 50);
    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId('2'),
        position: position);
    markers.add(marker);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return err
        ? SizedBox.shrink()
        : SizedBox(
            width: double.infinity,
            height: 300,
            child: Stack(
              children: [
                GoogleMap(
                  // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  //   new Factory<OneSequenceGestureRecognizer>(
                  //     () => new EagerGestureRecognizer(),
                  //   ),
                  // ].toSet(),
                  zoomControlsEnabled: false,

                  // myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: centerLatLng, zoom: 12, bearing: 314),
                  mapType: MapType.terrain,
                  scrollGesturesEnabled: true,
                  onMapCreated: ((controller) async {
                    controllerGm = controller;
                  }),
                  markers: markers,
                  polylines: {
                    Polyline(
                      polylineId: PolylineId("polyline"),
                      points: polylines,
                      color: Colors.blue,
                      width: 5,
                    )
                  },
                ),
              ],
            ),
          );
  }
}
