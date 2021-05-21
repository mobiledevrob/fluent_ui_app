import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

class Divider extends StatelessWidget {
  /// Creates a divider.
  const Divider({
    Key? key,
    this.direction = Axis.horizontal,
    this.style,
    this.size,
  }) : super(key: key);

  /// The current direction of the slider. Uses [Axis.horizontal] by default
  final Axis direction;

  /// The `style` of the divider. It's mescled with [ThemeData.dividerThemeData]
  final DividerThemeData? style;

  /// The size of the divider. The opposite of the [DividerThemeData.thickness]
  final double? size;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty(
      'size',
      size,
      ifNull: 'indeterminate',
      defaultValue: 1.0,
    ));
    properties.add(DiagnosticsProperty('style', style));
    properties.add(EnumProperty(
      'direction',
      direction,
      defaultValue: Axis.horizontal,
    ));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final style = DividerThemeData.standard(FluentTheme.of(context)).copyWith(
      FluentTheme.of(context).dividerTheme.copyWith(this.style),
    );
    return AnimatedContainer(
      duration: FluentTheme.of(context).fastAnimationDuration,
      curve: FluentTheme.of(context).animationCurve,
      height: direction == Axis.horizontal ? style.thickness : size,
      width: direction == Axis.vertical ? style.thickness : size,
      margin: style.margin?.call(direction),
      decoration: style.decoration,
    );
  }
}

@immutable
class DividerThemeData with Diagnosticable {
  /// The thickness of the style.
  ///
  /// If it's horizontal, it corresponds to the divider
  /// `height`, otherwise it corresponds to its `width`
  final double? thickness;

  /// The decoration of the style. If null, defaults to a
  /// [BoxDecoration] with a `Color(0xFFB7B7B7)` for light
  /// mode and `Color(0xFF484848)` for dark mode
  final Decoration? decoration;

  /// The margin callback of the style.
  final EdgeInsetsGeometry Function(Axis direction)? margin;

  const DividerThemeData({this.thickness, this.decoration, this.margin});

  factory DividerThemeData.standard(ThemeData style) {
    return DividerThemeData(
      thickness: 1,
      margin: (direction) {
        if (direction == Axis.horizontal)
          return EdgeInsets.symmetric(horizontal: 10);
        else
          return EdgeInsets.symmetric(vertical: 10);
      },
      decoration: () {
        if (style.brightness == Brightness.light) {
          return BoxDecoration(color: Color(0xFFB7B7B7));
        } else {
          return BoxDecoration(color: Color(0xFF484848));
        }
      }(),
    );
  }

  DividerThemeData copyWith(DividerThemeData? style) {
    if (style == null) return this;
    return DividerThemeData(
      decoration: style.decoration ?? decoration,
      margin: style.margin ?? margin,
      thickness: style.thickness ?? thickness,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration));
    properties.add(ObjectFlagProperty.has('margin', margin));
    properties.add(DoubleProperty('thickness', thickness, defaultValue: 1.0));
  }
}
