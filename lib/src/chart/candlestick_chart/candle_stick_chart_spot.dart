import 'package:fl_chart/fl_chart.dart';

class CandleStickSpot extends FlSpot {
  const CandleStickSpot(
    super.x,
    super.y,
    this.open,
    this.high,
    this.low,
    this.close,
  );

  final double open;
  final double high;
  final double low;
  final double close;
}
