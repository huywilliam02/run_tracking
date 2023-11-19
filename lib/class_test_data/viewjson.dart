import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/model/data_model_strava.dart';

class ViewJson extends StatelessWidget {
  DataModelStrava modelStrava;
  ViewJson({super.key, required this.modelStrava});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Json"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            JsonViewer(modelStrava.toJson()),
          ],
        ),
      ),
    );
  }
}
