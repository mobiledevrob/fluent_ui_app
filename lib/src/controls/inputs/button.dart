import 'dart:ui' show lerpDouble;

import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../utils/hover_button.dart';

enum _ButtonType { def, icon, toggle }

/// A button gives the user a way to trigger an immediate action
///
/// ![Button Preview](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/images/controls/button.png)
///
/// See also:
///   - [IconButton]. A button but with an icon
///   - [ToggleButton]. A button that can be on or off
///   - [HoverButton]. A base widget to implement any input fluent-like input
class Button extends StatefulWidget {
  /// Creates a fluent-styled button.
  ///
  /// You can't provide both [child] and [builder], but you must provide
  /// at least one of them.
  const Button({
    Key? key,
    this.child,
    this.builder,
    this.style,
    this.onPressed,
    this.onLongPress,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  })  : assert(
          child != null || builder != null,
          'You can NOT provide both child and builder',
        ),
        type = _ButtonType.def,
        super(key: key);

  /// Creates a button with an icon. Uses [IconButton] under the hood
  Button.icon({
    Key? key,
    required Widget icon,
    ButtonThemeData? style,
    IconThemeButtonStateBuilder? iconTheme,
    this.onPressed,
    this.onLongPress,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  })  : child = IconButton(
          icon: icon,
          onPressed: onPressed,
          onLongPress: onLongPress,
          semanticLabel: semanticLabel,
          style: style,
          iconTheme: iconTheme,
          focusNode: focusNode,
        ),
        style = null,
        type = _ButtonType.icon,
        builder = null,
        super(key: key);

  /// Creates a button that can be on or of.
  /// Uses a [ToggleButton] under the hood
  Button.toggle({
    Key? key,
    required bool checked,
    required ValueChanged<bool> onChanged,
    Widget? child,
    ToggleButtonThemeData? style,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  })  : child = ToggleButton(
          checked: checked,
          onChanged: onChanged,
          child: child,
          focusNode: focusNode,
          semanticLabel: semanticLabel,
          style: style,
        ),
        style = null,
        onPressed = null,
        onLongPress = null,
        type = _ButtonType.toggle,
        builder = null,
        super(key: key);

  final _ButtonType type;

  /// The content of the button. Usually a [Text] widget.
  ///
  /// If you want to use an [Icon], use an [IconButtno] instead
  final Widget? child;

  /// The style of the button. If non-null, it's mescled with [ThemeData.buttonThemeData]
  final ButtonThemeData? style;

  /// Callback to when the button get pressed.
  /// If `null`, the button will be considered disabled
  final VoidCallback? onPressed;

  /// Callback to when the button gets pressed for a long time.
  final VoidCallback? onLongPress;

  /// {@macro fluent_ui.controls.inputs.HoverButton.semanticLabel}
  final String? semanticLabel;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Build the button according to its current state.
  ///
  /// See also:
  ///   - [ButtonStates], the state a button can have
  final ButtonStateWidgetBuilder? builder;

  /// Whether the button is enabled or not.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>(
      'onPressed',
      onPressed,
      ifNull: enabled ? 'no on pressed' : 'disabled',
    ));
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('onLongPress', onPressed),
    );
    properties.add(DiagnosticsProperty<ButtonThemeData>('style', style));
    properties.add(ObjectFlagProperty<FocusNode>.has('focusNode', focusNode));
  }

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool get enabled => widget.enabled;

  double buttonScale = 1;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case _ButtonType.icon:
      case _ButtonType.toggle:
        return widget.child!;
      case _ButtonType.def:
      default:
        break;
    }
    assert(debugCheckHasFluentTheme(context));
    final style = ButtonTheme.of(context).copyWith(widget.style);
    return HoverButton(
      semanticLabel: widget.semanticLabel,
      margin: style.margin,
      focusNode: widget.focusNode,
      cursor: style.cursor,
      autofocus: widget.autofocus,
      onTapDown: !enabled
          ? null
          : () {
              if (mounted)
                setState(() => buttonScale = style.scaleFactor ?? 0.95);
            },
      onLongPressStart: !enabled
          ? null
          : () {
              if (mounted)
                setState(() => buttonScale = style.scaleFactor ?? 0.95);
            },
      onLongPressEnd: !enabled
          ? null
          : () {
              if (mounted) setState(() => buttonScale = 1);
            },
      onPressed: !enabled
          ? null
          : () async {
              widget.onPressed!();
              if (mounted)
                setState(() => buttonScale = style.scaleFactor ?? 0.95);
              await Future.delayed(Duration(milliseconds: 120));
              if (mounted) setState(() => buttonScale = 1);
            },
      onLongPress: widget.onLongPress,
      builder: (context, state) {
        final textStyle = (style.textStyle?.resolve(state)) ?? TextStyle();
        Widget child = AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(buttonScale, buttonScale, 1.0),
          duration: FluentTheme.of(context).fastAnimationDuration,
          curve: FluentTheme.of(context).animationCurve,
          padding: style.padding,
          decoration: style.decoration?.resolve(state),
          child: AnimatedDefaultTextStyle(
            duration: FluentTheme.of(context).fastAnimationDuration,
            curve: FluentTheme.of(context).animationCurve,
            style: textStyle,
            textAlign: TextAlign.center,
            child: IconTheme.merge(
              data: IconThemeData(color: textStyle.color),
              child: widget.child ?? widget.builder!(context, state),
            ),
          ),
        );
        return FocusBorder(
          child: child,
          focused: state.isFocused,
        );
      },
    );
  }
}

class ButtonTheme extends InheritedWidget {
  const ButtonTheme({
    Key? key,
    required this.child,
    required this.data,
  }) : super(key: key, child: child);

  final Widget child;
  final ButtonThemeData data;

  static ButtonThemeData of(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ButtonThemeData.standard(FluentTheme.of(context)).copyWith(
      context.dependOnInheritedWidgetOfExactType<ButtonTheme>()?.data ??
          FluentTheme.of(context).buttonTheme,
    );
  }

  @override
  bool updateShouldNotify(ButtonTheme oldWidget) {
    return oldWidget.data != data;
  }
}

@immutable
class ButtonThemeData with Diagnosticable {
  final ButtonState<Decoration?>? decoration;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final double? scaleFactor;

  final ButtonState<MouseCursor>? cursor;

  final ButtonState<TextStyle?>? textStyle;

  const ButtonThemeData({
    this.decoration,
    this.padding,
    this.margin,
    this.scaleFactor,
    this.cursor,
    this.textStyle,
  });

  factory ButtonThemeData.standard(ThemeData style) {
    return ButtonThemeData(
      cursor: style.inputMouseCursor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(4),
      decoration: ButtonState.resolveWith((states) {
        return BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: buttonColor(style, states),
        );
      }),
      scaleFactor: 0.95,
      textStyle: ButtonState.resolveWith(
        (states) => style.typography.body!.copyWith(
          color: states.isDisabled ? style.disabledColor : null,
        ),
      ),
    );
  }

  static ButtonThemeData lerp(
    ButtonThemeData? a,
    ButtonThemeData? b,
    double t,
  ) {
    return ButtonThemeData(
      decoration: ButtonState.lerp<Decoration>(
          a?.decoration, b?.decoration, t, Decoration.lerp),
      cursor: t < 0.5 ? a?.cursor : b?.cursor,
      textStyle: ButtonState.lerp<TextStyle>(
          a?.textStyle, b?.textStyle, t, TextStyle.lerp),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      scaleFactor: lerpDouble(a?.scaleFactor, b?.scaleFactor, t),
    );
  }

  ButtonThemeData copyWith(ButtonThemeData? style) {
    if (style == null) return this;
    return ButtonThemeData(
      decoration: style.decoration ?? decoration,
      cursor: style.cursor ?? cursor,
      textStyle: style.textStyle ?? textStyle,
      margin: style.margin ?? margin,
      padding: style.padding ?? padding,
      scaleFactor: style.scaleFactor ?? scaleFactor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ButtonState<Decoration?>?>.has(
      'decoration',
      decoration,
    ));
    properties
        .add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('margin', margin));
    properties.add(DoubleProperty('scaleFactor', scaleFactor));
    properties.add(ObjectFlagProperty<ButtonState<MouseCursor>?>.has(
      'cursor',
      cursor,
    ));
    properties.add(ObjectFlagProperty<ButtonState<TextStyle?>?>.has(
      'textStyle',
      textStyle,
    ));
  }

  static Color buttonColor(ThemeData style, Set<ButtonStates> states) {
    late Color color;
    if (style.brightness == Brightness.light) {
      if (states.isDisabled)
        color = Color(0xFFcccccc);
      else if (states.isPressing)
        color = Colors.grey[70];
      else if (states.isHovering)
        color = Colors.grey[40];
      else
        color = Colors.grey[50];
      return color;
    } else {
      if (states.isPressing) {
        // Value eyeballed from Windows 10
        color = Color(0xFF666666);
      } else if (states.isHovering)
        color = Colors.grey[170];
      else {
        // Value eyeballed from Windows 10
        // Used when the state is not recieving any user
        // interaction or is disabled
        color = Color(0xFF333333);
      }
      return color;
    }
  }

  static Color checkedInputColor(ThemeData style, Set<ButtonStates> states) {
    Color color = style.accentColor;
    if (states.isDisabled)
      return style.disabledColor;
    else if (states.isHovering)
      return color.withOpacity(0.70);
    else if (states.isPressing) return color.withOpacity(0.90);
    return color;
  }

  static Color uncheckedInputColor(ThemeData style, Set<ButtonStates> states) {
    if (style.brightness == Brightness.light) {
      if (states.isDisabled) return style.disabledColor;
      if (states.isPressing) return Colors.grey[70];
      if (states.isHovering) return Colors.grey[40];
      return Colors.grey[40].withOpacity(0);
    } else {
      if (states.isDisabled) return style.disabledColor;
      if (states.isPressing) return Colors.grey[130];
      if (states.isHovering) return Colors.grey[150];
      return Colors.grey[150].withOpacity(0);
    }
  }
}
