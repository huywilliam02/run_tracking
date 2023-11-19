import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../tracking_map_v2/model/streamdata.dart';

class ChartElevation extends StatelessWidget {
  ChartElevation({super.key, required this.model});
  final StreamData model;

  @override
  Widget build(BuildContext context) {
    return _buildTrendLineForecastChart(model);
  }

  Widget _buildTrendLineForecastChart(StreamData model) {
    final List<Color> color = <Color>[];
    color.add(Colors.orange[50]!);
    color.add(Colors.orange[200]!);
    color.add(Colors.orange);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);
    return SafeArea(
      child: Center(
          child: SingleChildScrollView(
        child: Container(
            child: SfCartesianChart(

                primaryXAxis: NumericAxis(
                  // isInversed: true,
                  labelAlignment: LabelAlignment.start,
                  visibleMinimum: 0,
                  // interval: 1,
                  labelFormat: '{value}',
                  labelRotation: 5,
                  // minimum: ,
                  // tickPosition: TickPosition.inside,
                  // rangePadding: ChartRangePadding.auto,
                  // visibleMaximum: model.splitsMetric.length.toDouble() + 2,
                  // title: AxisTitle(text: "Distance(KM)")
                ),
                primaryYAxis: NumericAxis(
                  //     i
                  // isInversed: true,
                  //  isVisible: false,
                  //  visibleMaximum: ,
                  // interval: 0.2,
                  // labelFormat: '{value}m',
                  // minimum: minY == 2 ? 0 : minY,
                  labelAlignment: LabelAlignment.center,
                  // minorTicksPerInterval: 3
                  // numberFormat: NumberFormat.compact(),
                  // desiredIntervals: ,
                  // visibleMaximum: maxY,
                  // visibleMinimum: minY,
                  // rangePadding: ChartRangePadding.auto,
                ),
                series: <ChartSeries>[
              AreaSeries<double, double>(
                  trendlines: <Trendline>[
                    Trendline(
                        type: TrendlineType.movingAverage,
                        width: 3,
                        color: Colors.red,
                        dashArray: <double>[15, 3, 3, 3],
                        onRenderDetailsUpdate: (TrendlineRenderParams args) {})
                  ],
                  gradient: gradientColors,
                  // trendlines: <Trendline>[
                  //   Trendline(
                  //       type: TrendlineType.logarithmic,
                  //       width: 3,
                  //       color: Colors.red,
                  //       dashArray: <double>[5, 5, 5, 5],
                  //       onRenderDetailsUpdate: (TrendlineRenderParams args) {
                  //         // _rSquare =
                  //         //     double.parse((args.rSquaredValue).toStringAsFixed(4))
                  //         //         .toString();
                  //         // _slope = args.slope;
                  //         // _intercept = args.intercept;
                  //         // // _getSlopeEquation(_slope, _intercept);
                  //         // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         //   if (_displayRSquare || _displaySlopeEquation) {
                  //         //     setState(() {});
                  //         //   }
                  //         // });
                  //       })
                  // ],
                  dataSource: model.distance,
                  // splineType: SplineType.cardinal,
                  // cardinalSplineTension: 0.9,
                  xValueMapper: (double data, _) => (data / 1000).toDouble(),
                  yValueMapper: (double data, _) {
                    // print((model.time[_] / 60) /
                    //     (model.distance[_] == 0
                    //         ? 0.02
                    //         : model.distance[_] / 1000));
                    return model.altitude[_].toPrecision(2);
                  })
            ])),
      )),
    );
  }
}
