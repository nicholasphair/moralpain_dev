import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moralpain/thermometer/cubit/thermometer_cubit.dart';
import 'package:moralpain/assets/constants.dart' as Constants;

class ThermometerSliderTrackShape extends SliderTrackShape {
  // TODO (nphair): Parameterize these.
  final double borderThickness = 1.5;
  final Color borderColor = Color(0xFF232D4B);
  final Color inactiveFillColor = Colors.white;
  final Color activeFillColor = Colors.red;
  final activeFillColorSteps = [
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.red,
  ];
  final Color measurementLineColor = Color(0xFF232D4B);
  final int thermometerSections = 10;

  int maxFillSection = 0;

  ThermometerSliderTrackShape(int maxFillSection) {
    this.maxFillSection = maxFillSection;
  }

  /**
   * The box the slider itself will be placed in by the framework.
   */
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = true,
  }) {
    assert(sliderTheme.overlayShape != null);
    assert(sliderTheme.trackHeight != null);

    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;

    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    //assert(parentBox.paintBounds.height > trackHeight);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width - overlayWidth;
    final double trackBottom = trackTop + trackHeight;

    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    var bbox = Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);

    // NB (nphair): There is a more direct way to achieve this rectangle but
    // this will work for now.
    var thermometerBaseRadius = bbox.height / 16;
    return Rect.fromPoints(
        bbox.topLeft.translate(thermometerBaseRadius * 2, 0), bbox.bottomRight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      bool isEnabled = false,
      bool isDiscrete = true,
      required TextDirection textDirection}) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    // Paint Constants.
    final inactiveFillPaint = Paint()..color = inactiveFillColor;
    final activeFillPaint = Paint()..color = activeFillColor;
    final borderPaint = Paint()..color = borderColor;
    final measurementLinePaint = Paint()
      ..color = measurementLineColor
      ..strokeWidth = 2.0;
    var borderStyle = BorderSide(color: borderColor, width: borderThickness);

    // This is the rectangle the slider will be placed on. Our painting must
    // extend below it for the thermometer base.
    final Rect preferredRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    var thermometerBaseRadius = preferredRect.height / 16;

    var paintableRect = Rect.fromPoints(
        preferredRect.topLeft.translate(thermometerBaseRadius * -2, 0),
        preferredRect.bottomRight);

    var trackWidth = paintableRect.width;
    var trackCenterLeft = paintableRect.centerLeft;

    // Thermometer reference points and dimensions.
    var thermometerStemHeight = thermometerBaseRadius / 1.5;
    var thermometerBaseCenter =
        trackCenterLeft.translate(thermometerBaseRadius, 0);
    var thermometerStemOrigin = thermometerBaseCenter.translate(
        thermometerBaseRadius, thermometerStemHeight / -2);
    var thermometerTickWidth =
        (trackWidth - thermometerBaseRadius * 2) / thermometerSections;
    var thermometerTickLineScale = 2;

    // Thermometer base and border.
    // Note we overlap the first division for a smooth transition.
    context.canvas.drawCircle(thermometerBaseCenter,
        thermometerBaseRadius + borderThickness, borderPaint);

    context.canvas.drawCircle(
        thermometerBaseCenter, thermometerBaseRadius, fillPaintForSection(0));

    var firstSection = Rect.fromLTWH(
      thermometerBaseCenter.dx,
      thermometerBaseCenter.dy - (thermometerStemHeight / 2),
      thermometerBaseRadius,
      thermometerStemHeight,
    );
    context.canvas.drawRect(firstSection, fillPaintForSection(0));

    // All sections.
    for (var secIndex = 0; secIndex < thermometerSections; secIndex++) {
      var sectionOriginX =
          thermometerStemOrigin.dx + (secIndex * thermometerTickWidth);
      var sectionOriginY = thermometerStemOrigin.dy;

      // The section and its border.
      var section = Rect.fromLTWH(sectionOriginX, sectionOriginY,
          thermometerTickWidth, thermometerStemHeight);
      context.canvas.drawRect(section, fillPaintForSection(secIndex));

      paintBorder(context.canvas, section,
          top: borderStyle, bottom: borderStyle);
    }

    // Final Section.
    var sectionOriginX =
        thermometerStemOrigin.dx + (thermometerSections * thermometerTickWidth);
    var sectionOriginY = thermometerStemOrigin.dy;

    // The section and its border.
    var section = Rect.fromLTWH(sectionOriginX, sectionOriginY,
        thermometerTickWidth, thermometerStemHeight);
    paintBorder(context.canvas, section, left: borderStyle);
  }

  /**
   * Return the paint color for the section. 
   * 
   * When the number of fill colors does not divide evenly into the sections
   * pad the top sections.
   */
  Paint fillPaintForSection(int section) {
    if (section >= maxFillSection) {
      return Paint()..color = inactiveFillColor;
    }

    var colorStepCount = activeFillColorSteps.length;
    var remainder = thermometerSections % colorStepCount;
    var evenlyDivisibleSectionCount = thermometerSections - remainder;
    if (section >= evenlyDivisibleSectionCount) {
      return Paint()..color = activeFillColorSteps.last;
    }

    var sectionColorStepSize = evenlyDivisibleSectionCount ~/ colorStepCount;
    var step = section ~/ sectionColorStepSize;
    return Paint()..color = activeFillColorSteps[step];
  }
}

class ThermometerWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;

  ThermometerWidget({
    this.sliderHeight = 48,
    this.max = 10,
    this.min = 0,
  });

  @override
  _ThermometerWidgetState createState() => _ThermometerWidgetState();
}

class _ThermometerWidgetState extends State<ThermometerWidget> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    // Cubit here?
    print(MediaQuery.of(context).size.height);
    return BlocBuilder<ThermometerCubit, double>(builder: (context, state) {
      return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: MediaQuery.of(context).size.height,
            activeTrackColor: Colors.black,
            trackShape: ThermometerSliderTrackShape(_value.toInt()),
            showValueIndicator: ShowValueIndicator.never,
            valueIndicatorColor: Color(Constants.COLORS_UVA_BLUE),
            thumbShape: ThermometerThumbShape(),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
          ),
          child: Slider(
              label: "${_value.toInt()}",
              thumbColor: Colors.transparent,
              value: _value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _value = value;
                  context.read<ThermometerCubit>().set(_value);
                });
              }));
    });
  }
}

class ThermometerThumbShape extends RoundSliderThumbShape {
  final _indicatorShape = const RectangularSliderValueIndicatorShape();

  const ThermometerThumbShape();

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      textDirection: textDirection,
    );
    _indicatorShape.paint(
      context,
      center,
      activationAnimation: const AlwaysStoppedAnimation(1),
      enableAnimation: enableAnimation,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: 0.6,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
    );
  }
}
