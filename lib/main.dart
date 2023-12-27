import 'package:flutter/material.dart';
import 'package:pokemon_flutter/models/favorite.dart';
import 'package:pokemon_flutter/models/pokemon.dart';
import 'package:pokemon_flutter/state/theme_mode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'poke_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp前にThemeModeNotifierインスタンス作成
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModeNotifier = ThemeModeNotifier(pref);
  final pokemonsNotifier = PokemonsNotifier();
  final favoriteNotifier = FavoriteNotifier();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeNotifier>(
            // themeModeNotifierインスタンス作成（本来は作成するがrunApp前に作成したインスタンスを使用
            create: (context) => themeModeNotifier),
        ChangeNotifierProvider<PokemonsNotifier>(
            create: (context) => pokemonsNotifier),
        ChangeNotifierProvider<FavoriteNotifier>(
            create: (context) => favoriteNotifier)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Consumerで再描画される範囲を限定
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => MaterialApp(
        // mode（ThemeModeNotifierオブジェクト）の変更を検知して再描画
        title: 'Pokemon Flutter',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode.mode,
        home: const TopPage(),
      ),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({super.key});
  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeDex'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentbnb,
          children: const [PokeList(), Settings()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(
            () => currentbnb = index,
          )
        },
        currentIndex: currentbnb,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'setting')
        ],
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text('Dark/Light Mode'),
            trailing: Text((mode.mode == ThemeMode.system)
                ? 'System'
                : (mode.mode == ThemeMode.dark ? 'Dark' : 'Light')),
            onTap: () async {
              final ret =
                  await Navigator.of(context).push<ThemeMode>(MaterialPageRoute(
                builder: (context) => ThemeModeSelectionPage(init: mode.mode),
              ));
              if (ret != null) {
                mode.update(ret);
              } // preferenceにthemeの保存
            },
          ),
        ],
      ),
    );
  }
}

class ThemeModeSelectionPage extends StatefulWidget {
  const ThemeModeSelectionPage({
    Key? key,
    required this.init,
  }) : super(key: key);
  final ThemeMode init;

  @override
  ThemeModeSelectionPageState createState() => ThemeModeSelectionPageState();
}

class ThemeModeSelectionPageState extends State<ThemeModeSelectionPage> {
  late ThemeMode _current; // 後で代入するから一旦nullを許容してもらう

  @override
  void initState() {
    super.initState();
    _current = widget
        .init; // widgetを利用する場合、initStateをoverrideする。StfとStateのコンストラクタは同時に呼び出されるため、その後のcreateState内でないとwidgetを利用できない。
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop<ThemeMode>(context, _current),
            ),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: _current,
            title: const Text('System'),
            onChanged: (val) => {setState(() => _current = val!)},
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: _current,
            title: const Text('Dark'),
            onChanged: (val) => {setState(() => _current = val!)},
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: _current,
            title: const Text('Light'),
            onChanged: (val) => {setState(() => _current = val!)},
          ),
        ],
      )),
    );
  }
}
