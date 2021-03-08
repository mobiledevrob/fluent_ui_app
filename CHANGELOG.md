Date format: DD/MM/YYYY

## [1.0.1] - [06/03/2021]

- **FIX** `NavigationPanel` navigation index
- **FIX** `Slider`'s inactive color
- **FIDELITY** Scale animation of button press
- **FIDELITY** Improved `Slider` label fidelity
- **NEW** Split Button

## [1.0.0] - [05/03/2021]

- **NEW** Null-safety
- **NEW** New Icons Library
- **NEW** `NavigationPanelSectionHeader` and `NavigationPanelTileSeparator`
- **BREAKING** Removed `Snackbar`

## [0.0.9] - [03/03/2021]

- Export the icons library
- **NEW** `TextBox`

## [0.0.8] - [01/03/2021]

- **NEW** `ContentDialog` 🎉
- **NEW** `RatingControl` 🎉
- **NEW** `NavigationPanel` 🎉
- Improved `Button` fidelity

## [0.0.7] - [28/02/2021]

- **NEW** `Slider` 🎉
- Use physical model for elevation instead of box shadows
- Improved TODO

## [0.0.6] - [27/02/2021]

- **FIXED** Button now detect pressing
- **FIXED** `ToggleSwitch` default thumb is now animated
- **FIXED** Improved `ToggleSwitch` fidelity
  **FIXED** Darker color for button press.
- **NEW** **THEMING**
  - `Style.activeColor`
  - `Style.inactiveColor`
  - `Style.disabledColor`
  - `Style.animationDuration`
  - `Style.animationCurve`

## [0.0.5] - [27/02/2021]

- `ToggleSwitch` is now stable 🎉
- **NEW** `DefaultToggleSwitchThumb`
- **NEW** `ToggleButton`
- New toast lib: [fl_toast](https://pub.dev/packages/fl_toast)
- Screenshot on the readme. (Fixes [#1](https://github.com/bdlukaa/fluent_ui/issues/1))

## [0.0.4] - [22/02/2021]

- New fluent icons library: [fluentui_icons](https://pub.dev/packages/fluentui_icons)
- Re-made checkbox with more fidelity
- Refactored the following widgets to follow the theme accent color:
  - `Checkbox`
  - `ToggleSwitch`
  - `RadioButton`
- Added accent colors to widget. Use [this](https://docs.microsoft.com/en-us/windows/uwp/design/style/images/color/windows-controls.svg) as a base

## [0.0.3] - Theming update - [21/02/2021]

- **HIGHLIGHT** A whole new [documentation](https://github.com/bdlukaa/fluent_ui/wiki)
- Scaffold now works as expected.
- Improved theming checking
- **NEW**
  - `null` (thirdstate) design on `Checkbox`. (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/checkbox))
  - Now you can use the `Decoration` to style the inputs
- **BREAKING**:
  - Removed `Button.action`
  - Removed `Button.compound`
  - Removed `Button.primary`
  - Removed `Button.contextual`
  - Removed `AppBar`
  - Now the default theme uses accent color instead of a predefined color (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/style/color#accent-color))
- **FIXED**:
  - `ToggleSwitch` can NOT receive null values

## [0.0.2] - [18/02/2021]

- The whole library was rewritten following [this](https://docs.microsoft.com/en-us/windows/uwp/design/)
- Tooltip's background color is now opaque (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/tooltips))
- Dropdown button now works as expected
- **FIXED**:
  - Snackbar now is dismissed even if pressing or hovering
  - Margin is no longer used as part of the clickable button
- **BREAKING**:
  - Renamed `Toggle` to `ToggleSwitch` (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/toggles))
  - Removed `BottomNavigationBar`. It's recommended to use top navigation (pivots)
  - Removed `IconButton.menu`
- **NEW**:
  - NavigationPanel (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/layout/page-layout#left-nav))
  - Windows project on example
  - RadioButton (Follows [this](https://docs.microsoft.com/en-us/windows/uwp/design/controls-and-patterns/radio-button))

## [0.0.1]

- Initial release
