import 'dart:math';

import 'package:fl_chart/src/chart/candlestick_chart/candle_stick_chart_spot.dart';
import 'package:flutter/rendering.dart';

import 'package:fl_chart/src/chart/candlestick_chart/candle_stick_chart_data.dart'; // Import your data class

class CandleStickChartRenderer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            ContainerBoxParentData<RenderBox>> {
  CandleStickChartRenderer({required CandleStickChartData data}) : _data = data;

  CandleStickChartData get data => _data;
  CandleStickChartData _data;
  set data(CandleStickChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = CandleStickContainerBoxParentData();
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    // No need to layout children for now
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    if (data.candleStickSpots.isEmpty) {
      return;
    }

    final double xShift = data.candleWidth / 2; // Half the width of the body

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (final CandleStickSpot spot in data.candleStickSpots) {
      // 1. Coordinate Mapping
      final double x = _getXCoordinate(spot.x);
      final double openY = _getYCoordinate(spot.open);
      final double closeY = _getYCoordinate(spot.close);
      final double highY = _getYCoordinate(spot.high);
      final double lowY = _getYCoordinate(spot.low);

      final double left = x - xShift + offset.dx;
      final double right = x + xShift + offset.dx;
      final double top = min(openY, closeY);
      final double bottom = max(openY, closeY);

      // 2. Color Logic
      paint.color = spot.close > spot.open ? data.bullColor : data.bearColor;

      // 3. Shape Drawing
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);

      // 4. Draw Wicks (if enabled)
      if (data.showCandleWick) {
        canvas.drawLine(Offset(x + offset.dx, highY),
            Offset(x + offset.dx, top), paint); // Upper wick
        canvas.drawLine(Offset(x + offset.dx, lowY),
            Offset(x + offset.dx, bottom), paint); // Lower wick
      }
    }
  }

  // You will need to implement these coordinate mapping functions:
  double _getXCoordinate(double x) {
    // TODO: Implement coordinate mapping for the x-axis based on fl_chart's logic
    throw UnimplementedError();
  }

  double _getYCoordinate(double y) {
    // TODO: Implement coordinate mapping for the y-axis based on fl_chart's logic
    throw UnimplementedError();
  }
}

class CandleStickContainerBoxParentData
    extends ContainerBoxParentData<RenderBox> {}
