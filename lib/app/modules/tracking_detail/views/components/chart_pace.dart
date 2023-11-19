import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tracker_run/class_test_data/calculate.dart';

import '../../../tracking_map_v2/model/streamdata.dart';

class ChartPace extends StatelessWidget {
  ChartPace({super.key, required this.model, required this.type});
  final StreamData model;
  final String type;

  @override
  Widget build(BuildContext context) {
    print(model.latlng.length);
    return _buildTrendLineForecastChart(model);
  }

  Widget _buildTrendLineForecastChart(StreamData model) {
    final List<Color> color = <Color>[];
    color.add(Colors.blue[50]!);
    color.add(Colors.blue[200]!);
    color.add(Colors.blue);

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
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  // minorTicksPerInterval: 5 ,
                  // decimalPlaces: 2,
                  // autoScrollingDelta: 10,
                  // interval: 1,
                  // minorTicksPerInterval: ,
                  axisLabelFormatter: (AxisLabelRenderDetails args) {
                     if (type == "RUN") {
                         double phut = double.parse(args.text);
                    return ChartAxisLabel(
                        CalculateUtils.changeToMinutesSecond(phut),
                        args.textStyle.copyWith(fontWeight: FontWeight.bold));
                    }else{
                      return ChartAxisLabel(
                     args.text,
                        args.textStyle.copyWith(fontWeight: FontWeight.bold)) ;
                    }
                
                  },
                  // minimum: minY == 2 ? 0 : minY,
                  labelAlignment: LabelAlignment.center,
                  numberFormat: NumberFormat.compact(),
                  desiredIntervals: 5,
                  // visibleMaximum: maxY,
                  // visibleMinimum: minY,
                  rangePadding: ChartRangePadding.auto,
                ),
                series: <ChartSeries>[
              AreaSeries<double, double>(
                  trendlines: <Trendline>[
                    Trendline(
                        type: TrendlineType.logarithmic,
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
                    if (type == "RUN") {
                      return model.distance[_] == 0
                          ? 0
                          : ((model.time[_] / 60) / (model.distance[_] / 1000));
                    }else{
                      return (model.speed[_]*3.6).toPrecision(2);
                    }
                  })
            ])),
      )),
    );
  }
}
