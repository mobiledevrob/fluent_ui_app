import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'screens/colors.dart';
import 'screens/forms.dart';
import 'screens/inputs.dart';
import 'screens/others.dart';
import 'screens/settings.dart';

import 'theme.dart';

const String appTitle = 'Fluent UI Showcase for Flutter';

late bool darkMode;

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The platforms the plugin support (01/04/2021 - DD/MM/YYYY):
  //   - Windows
  //   - Web
  //   - Android
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  runApp(MyApp());
  if (isDesktop)
    doWhenWindowReady(() {
      final win = appWindow;
      final initialSize = Size(600, 450);
      win.minSize = Size(600, 450);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = appTitle;
      win.show();
    });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {'/': (_) => MyHomePage()},
          navigatorObservers: [ClearFocusOnPush()],
          theme: ThemeData(
            accentColor: appTheme.color,
            brightness: appTheme.mode == ThemeMode.system
                ? darkMode
                    ? Brightness.dark
                    : Brightness.light
                : appTheme.mode == ThemeMode.dark
                    ? Brightness.dark
                    : Brightness.light,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
        );
      },
    );
  }
}

// This is the current solution for this. See https://github.com/flutter/flutter/issues/48464
class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  final colorsController = ScrollController();
  final settingsController = ScrollController();

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationPanel(
      menu: NavigationPanelMenuItem(
        icon: Icon(Icons.dehaze),
        label: Text('Showcase'),
      ),
      currentIndex: index,
      items: [
        NavigationPanelSectionHeader(
          header: Text('Cool Navigation Panel Header'),
        ),
        NavigationPanelItem(
          icon: Icon(Icons.input),
          label: Text('Inputs'),
          onTapped: () => setState(() => index = 0),
        ),
        NavigationPanelItem(
          icon: Icon(Icons.format_align_center),
          label: Text('Forms'),
          onTapped: () => setState(() => index = 1),
        ),
        NavigationPanelTileSeparator(),
        NavigationPanelItem(
          icon: Icon(Icons.miscellaneous_services),
          label: Text('Others'),
          onTapped: () => setState(() => index = 2),
        ),
        NavigationPanelItem(
          icon: Icon(Icons.color_lens),
          label: Text('Colors'),
          onTapped: () => setState(() => index = 3),
        ),
      ],
      bottom: NavigationPanelItem(
        icon: Icon(Icons.settings),
        label: Text('Settings'),
        onTapped: () => setState(() => index = 4),
      ),
      appBar: NavigationPanelAppBar(
        title: Text(appTitle),
        remainingSpace: isDesktop
            ? WindowTitleBarBox(
                child: Row(children: [
                  Expanded(child: MoveWindow()),
                  WindowButtons(),
                ]),
              )
            : null,
      ),
      body: NavigationPanelBody(index: index, children: [
        InputsPage(),
        Forms(),
        Others(),
        ColorsPage(controller: colorsController),
        Settings(controller: settingsController),
      ]),
    );
    return SizedBox();
    // return Scaffold(
    //   topBar: isDesktop
    //       ? WindowTitleBarBox(
    //           child: Row(children: [
    //             Expanded(child: MoveWindow()),
    //             WindowButtons(),
    //           ]),
    //         )
    //       : null,
    //   left: NavigationPanel(
    //     menu: NavigationPanelMenuItem(
    //       icon: Icon(Icons.dehaze),
    //       label: Text('Showcase'),
    //     ),
    //     currentIndex: index,
    //     items: [
    //       NavigationPanelSectionHeader(
    //         header: Text('Cool Navigation Panel Header'),
    //       ),
    //       NavigationPanelItem(
    //         icon: Icon(Icons.input),
    //         label: Text('Inputs'),
    //         onTapped: () => setState(() => index = 0),
    //       ),
    //       NavigationPanelItem(
    //         icon: Icon(Icons.format_align_center),
    //         label: Text('Forms'),
    //         onTapped: () => setState(() => index = 1),
    //       ),
    //       NavigationPanelTileSeparator(),
    //       NavigationPanelItem(
    //         icon: Icon(Icons.miscellaneous_services),
    //         label: Text('Others'),
    //         onTapped: () => setState(() => index = 2),
    //       ),
    //       NavigationPanelItem(
    //         icon: Icon(Icons.color_lens),
    //         label: Text('Colors'),
    //         onTapped: () => setState(() => index = 3),
    //       ),
    //     ],
    //     bottom: NavigationPanelItem(
    //       icon: Icon(Icons.settings),
    //       label: Text('Settings'),
    //       onTapped: () => setState(() => index = 4),
    //     ),
    //   ),
    //   body: NavigationPanelBody(index: index, children: [
    //     InputsPage(),
    //     Forms(),
    //     Others(),
    //     ColorsPage(controller: colorsController),
    //     Settings(controller: settingsController),
    //   ]),
    // );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final ThemeData theme = FluentTheme.of(context);
    final buttonColors = WindowButtonColors(
      iconNormal: theme.inactiveColor,
      iconMouseDown: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
      mouseOver: ButtonThemeData.buttonColor(theme, ButtonStates.hovering),
      mouseDown: ButtonThemeData.buttonColor(theme, ButtonStates.pressing),
    );
    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red.light,
      mouseDown: Colors.red,
      iconNormal: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
    );
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
