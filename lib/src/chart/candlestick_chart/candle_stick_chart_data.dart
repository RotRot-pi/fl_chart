import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_data.dart';
import 'package:fl_chart/src/chart/candlestick_chart/candle_stick_chart_spot.dart';

import 'package:flutter/material.dart';

class CandleStickChartData extends AxisChartData {
  CandleStickChartData({
    required this.candleStickSpots,
    this.bullColor = Colors.green,
    this.bearColor = Colors.red,
    this.showCandleWick = true,
    this.candleWidth = 0.7,
    required super.titlesData,
    required super.minX,
    required super.maxX,
    required super.minY,
    required super.maxY,
    required super.touchData,
  });

  final List<CandleStickSpot> candleStickSpots;
  final Color bullColor;
  final Color bearColor;
  final bool showCandleWick;
  final double candleWidth;

  @override
  CandleStickChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is CandleStickChartData && b is CandleStickChartData) {
      return CandleStickChartData(
        candleStickSpots:
            lerpCandleStickSpotList(a.candleStickSpots, b.candleStickSpots, t),
        bullColor: Color.lerp(a.bullColor, b.bullColor, t)!,
        bearColor: Color.lerp(a.bearColor, b.bearColor, t)!,
        showCandleWick: b.showCandleWick, // No need to lerp a boolean
        candleWidth: lerpDouble(a.candleWidth, b.candleWidth, t)!,
        minX: lerpDouble(a.minX, b.minX, t)!,
        maxX: lerpDouble(a.maxX, b.maxX, t)!,
        minY: lerpDouble(a.minY, b.minY, t)!,
        maxY: lerpDouble(a.maxY, b.maxY, t)!,
        titlesData: a.titlesData,
        touchData: a.touchData,
        // ... lerp other properties from AxisChartData as needed
      );
    } else {
      throw Exception('Illegal State');
    }
  }
}

List<CandleStickSpot> lerpCandleStickSpotList(
  List<CandleStickSpot> a,
  List<CandleStickSpot> b,
  double t,
) {
  if (a.isEmpty && b.isEmpty) {
    return const [];
  }

  if (a.isEmpty) {
    return b;
  }

  if (b.isEmpty) {
    return a;
  }

  final int length = max(a.length, b.length);
  return List.generate(length, (i) {
    final CandleStickSpot? spotA = i < a.length ? a[i] : null;
    final CandleStickSpot? spotB = i < b.length ? b[i] : null;

    return CandleStickSpot(
      lerpDouble(spotA?.x ?? spotB!.x, spotB?.x ?? spotA!.x, t)!,
      lerpDouble(spotA?.y ?? spotB!.y, spotB?.y ?? spotA!.y, t)!,
      lerpDouble(spotA?.open ?? spotB!.open, spotB?.open ?? spotA!.open, t)!,
      lerpDouble(spotA?.high ?? spotB!.high, spotB?.high ?? spotA!.high, t)!,
      lerpDouble(spotA?.low ?? spotB!.low, spotB?.low ?? spotA!.low, t)!,
      lerpDouble(
          spotA?.close ?? spotB!.close, spotB?.close ?? spotA!.close, t)!,
    );
  });
}
