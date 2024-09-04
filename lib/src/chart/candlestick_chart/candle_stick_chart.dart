import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'candle_stick_chart_data.dart';
import 'candle_stick_chart_renderer.dart';

class CandleStickChart extends ImplicitlyAnimatedWidget {
  const CandleStickChart(
    this.data, {
    Key? key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          key: key,
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  final CandleStickChartData data;

  @override
  _CandleStickChartState createState() => _CandleStickChartState();
}

class _CandleStickChartState extends AnimatedWidgetBaseState<CandleStickChart> {
  /// We handle under the hood animations (implicit animations) via this tween,
  /// it lerps between the old [CandleStickChartData] to the new one.
  CandleStickChartDataTween? _candleStickChartDataTween;

  @override
  Widget build(BuildContext context) {
    final CandleStickChartData showingData = _getData();
    return AxisChartScaffoldWidget(
      data: showingData,
      chart: CandleStickChartLeaf(
        data: _candleStickChartDataTween!.evaluate(animation),
        targetData: showingData,
      ),
    );
  }

  CandleStickChartData _getData() {
    return widget
        .data; // You might need to add data validation/processing here later
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _candleStickChartDataTween = visitor(
      _candleStickChartDataTween,
      _getData(),
      (dynamic value) => CandleStickChartDataTween(
          begin: value as CandleStickChartData, end: widget.data),
    ) as CandleStickChartDataTween?;
  }
}

class CandleStickChartLeaf extends LeafRenderObjectWidget {
  const CandleStickChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
  });

  final CandleStickChartData data;
  final CandleStickChartData targetData;

  @override
  _RenderCandleStickChart createRenderObject(BuildContext context) =>
      _RenderCandleStickChart(
        // Create the concrete subclass
        data,
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderCandleStickChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData;
  }
}

// Concrete subclass of RenderCandleStickChart:
class _RenderCandleStickChart extends RenderCandleStickChart {
  _RenderCandleStickChart(super.data);

  @override
  bool hitTestSelf(Offset position) => true;

  // ... You will need to implement the other required methods from RenderBox here ...
  // ... For example:
  // @override
  // void performLayout() {
  //   // ...
  // }

  // @override
  // void paint(PaintingContext context, Offset offset) {
  //   // ...
  // }
}

class RenderCandleStickChart extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            ContainerBoxParentData<RenderBox>> {
  RenderCandleStickChart(
    CandleStickChartData data,
  ) : _data = data;

  CandleStickChartData get data => _data;
  CandleStickChartData _data;
  set data(CandleStickChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  CandleStickChartData get targetData => _targetData;
  late CandleStickChartData _targetData;
  set targetData(CandleStickChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    markNeedsPaint();
  }

  CandleStickChartRenderer? _renderer;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _renderer = CandleStickChartRenderer(data: data);
    adoptChild(_renderer!);
  }

  @override
  void detach() {
    dropChild(_renderer!);
    _renderer = null;
    super.detach();
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    _renderer!.layout(constraints, parentUsesSize: true);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _renderer!.paint(context, offset);
  }
}

/// Lerps a [CandleStickChartData] to another [CandleStickChartData] (handles animation for updating values)
class CandleStickChartDataTween extends Tween<CandleStickChartData> {
  CandleStickChartDataTween(
      {required CandleStickChartData begin, required CandleStickChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [CandleStickChartData] based on [t] value, check [Tween.lerp].
  @override
  CandleStickChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
// class CandleStickChart extends ImplicitlyAnimatedWidget {
//   const CandleStickChart(
//     this.data, {
//     Key? key,
//     Duration swapAnimationDuration = const Duration(milliseconds: 150),
//     Curve swapAnimationCurve = Curves.linear,
//   }) : super(
//           key: key,
//           duration: swapAnimationDuration,
//           curve: swapAnimationCurve,
//         );

//   final CandleStickChartData data;

//   @override
//   _CandleStickChartState createState() => _CandleStickChartState();
// }

// class _CandleStickChartState extends AnimatedWidgetBaseState<CandleStickChart> {
//   /// We handle under the hood animations (implicit animations) via this tween,
//   /// it lerps between the old [CandleStickChartData] to the new one.
//   CandleStickChartDataTween? _candleStickChartDataTween;

//   @override
//   Widget build(BuildContext context) {
//     final CandleStickChartData showingData = _getData();
//     return AxisChartScaffoldWidget(
//       data: showingData,
//       chart: CandleStickChartLeaf(
//         data: _candleStickChartDataTween!.evaluate(animation),
//         targetData: showingData,
//       ),
//     );
//   }

//   CandleStickChartData _getData() {
//     return widget.data; // You might need to add data validation/processing here later
//   }

//   @override
//   void forEachTween(TweenVisitor<dynamic> visitor) {
//     _candleStickChartDataTween = visitor(
//       _candleStickChartDataTween,
//       _getData(),
//       (dynamic value) => CandleStickChartDataTween(
//           begin: value as CandleStickChartData, end: widget.data),
//     ) as CandleStickChartDataTween?;
//   }
// }

// class CandleStickChartLeaf extends LeafRenderObjectWidget {
//   const CandleStickChartLeaf({
//     Key? key,
//     required this.data,
//     required this.targetData,
//   }) : super(key: key);

//   final CandleStickChartData data;
//   final CandleStickChartData targetData;

//   @override
//   RenderCandleStickChart createRenderObject(BuildContext context) =>
//       RenderCandleStickChart(
//         data,
//       );

//   @override
//   void updateRenderObject(
//       BuildContext context, covariant RenderCandleStickChart renderObject) {
//     renderObject
//       ..data = data
//       ..targetData = targetData;
//   }
// }

// class RenderCandleStickChart extends RenderBox
//     with ContainerRenderObjectMixin<RenderBox, ContainerBoxParentData<RenderBox>> {
//   RenderCandleStickChart(
//     CandleStickChartData data,
//   ) : _data = data;

//   CandleStickChartData get data => _data;
//   CandleStickChartData _data;
//   set data(CandleStickChartData value) {
//     if (_data == value) return;
//     _data = value;
//     markNeedsPaint();
//   }

//   CandleStickChartData get targetData => _targetData;
//   CandleStickChartData _targetData;
//   set targetData(CandleStickChartData value) {
//     if (_targetData == value) return;
//     _targetData = value;
//     markNeedsPaint();
//   }

//   CandleStickChartRenderer? _renderer;

//   @override
//   void attach(PipelineOwner owner) {
//     super.attach(owner);
//     _renderer = CandleStickChartRenderer(data: data);
//     adoptChild(_renderer!);
//   }

//   @override
//   void detach() {
//     dropChild(_renderer!);
//     _renderer = null;
//     super.detach();
//   }

//   @override
//   bool get sizedByParent => true;

//   @override
//   void performResize() {
//     size = constraints.biggest;
//   }

//   @override
//   void performLayout() {
//     _renderer!.layout(constraints, parentUsesSize: true);
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     _renderer!.paint(context, offset);
//   }
// }

// /// Lerps a [CandleStickChartData] to another [CandleStickChartData] (handles animation for updating values)
// class CandleStickChartDataTween extends Tween<CandleStickChartData> {
//   CandleStickChartDataTween(
//       {required CandleStickChartData begin, required CandleStickChartData end})
//       : super(begin: begin, end: end);

//   /// Lerps a [CandleStickChartData] based on [t] value, check [Tween.lerp].
//   @override
//   CandleStickChartData lerp(double t) => begin!.lerp(begin!, end!, t);
// }
