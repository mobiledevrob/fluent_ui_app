import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

const double _kBottomNavigationHeight = 48.0;

/// The navigation item used by [BottomNavigation]
class BottomNavigationItem {
  final Widget? title;

  final Widget icon;
  final Widget? selectedIcon;

  const BottomNavigationItem({
    required this.icon,
    this.selectedIcon,
    this.title,
  });
}

/// The bottom navigation displays icons and optional text at the
/// bottom of the screen for switching between different primary
/// destinations in an app.
/// 
/// It's usually used on [ScaffoldPage.bottomBar]
///
/// See also:
///   * [BottomNavigationItem], the items used by this widget
///   * [BottomNavigationThemeData], used to style this widget
///   * [ScaffoldPage], used to layout pages
class BottomNavigation extends StatelessWidget {
  /// Creates a bottom navigation
  ///
  /// [items] must have at least 2 items
  ///
  /// [index] must be in the range of 0 to [items.length]
  const BottomNavigation({
    Key? key,
    required this.items,
    required this.index,
    this.onChanged,
    this.style,
  })  : assert(items.length >= 2),
        assert(index >= 0 && index < items.length),
        super(key: key);

  /// The items displayed by this widget.
  final List<BottomNavigationItem> items;

  /// The selected index
  final int index;

  /// Called when the current index should be changed
  final ValueChanged<int>? onChanged;

  /// Used to style this bottom navigation bar. If non-null,
  /// it's mescled with [ThemeData.bottomNavigationTheme]
  final BottomNavigationThemeData? style;

  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final style = BottomNavigationThemeData.standart(FluentTheme.of(context)).copyWith(
      this.style,
    );
    return PhysicalModel(
      color: Colors.black,
      elevation: 8.0,
      shadowColor: FluentTheme.of(context).shadowColor,
      child: Container(
        height: _kBottomNavigationHeight,
        color: style.backgroundColor,
        child: Row(
          children: items.map((item) {
            final itemIndex = items.indexOf(item);
            return _BottomNavigationItem(
              key: ValueKey<BottomNavigationItem>(item),
              item: item,
              selected: index == itemIndex,
              onPressed: _disabled ? null : () => onChanged!(itemIndex),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    Key? key,
    required this.item,
    required this.selected,
    this.onPressed,
  }) : super(key: key);

  final BottomNavigationItem item;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = BottomNavigationThemeData.of(context);
    return Expanded(
      child: HoverButton(
        onPressed: onPressed,
        builder: (context, state) {
          final content =
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FluentTheme(
              data: FluentTheme.of(context).copyWith(
                iconTheme: IconThemeData(
                  color: selected ? style.selectedColor : style.inactiveColor,
                ),
              ),
              child: selected ? item.selectedIcon ?? item.icon : item.icon,
            ),
            if (item.title != null)
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: DefaultTextStyle(
                  style: FluentTheme.of(context).typography.caption!.copyWith(
                        color: selected
                            ? style.selectedColor
                            : style.inactiveColor,
                      ),
                  child: item.title!,
                ),
              ),
          ]);
          return FocusBorder(
            focused: state.isFocused,
            renderOutside: false,
            child: Container(
              color: ButtonThemeData.uncheckedInputColor(
                FluentTheme.of(context),
                state,
              ),
              child: content,
            ),
          );
        },
      ),
    );
  }
}

class BottomNavigationThemeData with Diagnosticable {
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? inactiveColor;

  const BottomNavigationThemeData({
    this.backgroundColor,
    this.selectedColor,
    this.inactiveColor,
  });

  factory BottomNavigationThemeData.standart(ThemeData style) {
    final isLight = style.brightness.isLight;
    return BottomNavigationThemeData(
      backgroundColor: isLight ? Color(0xFFf8f8f8) : Color(0xFF0c0c0c),
      selectedColor: style.accentColor,
      inactiveColor: style.disabledColor,
    );
  }

  static BottomNavigationThemeData of(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return BottomNavigationThemeData.standart(FluentTheme.of(context)).copyWith(
      FluentTheme.of(context).bottomNavigationTheme,
    );
  }

  BottomNavigationThemeData copyWith(BottomNavigationThemeData? other) {
    if (other == null) return this;
    return BottomNavigationThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      selectedColor: other.selectedColor ?? selectedColor,
      inactiveColor: other.inactiveColor ?? inactiveColor,
    );
  }
}
