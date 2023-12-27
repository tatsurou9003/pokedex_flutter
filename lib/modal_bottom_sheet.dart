import 'package:flutter/material.dart';

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet(
      {Key? key,
      required this.favMode,
      required this.gridMode,
      required this.changeFavMode,
      required this.changeGridMode})
      : super(key: key);
  final bool favMode;
  final Function(bool) changeFavMode;
  final bool gridMode;
  final Function(bool) changeGridMode;

  String mainText(bool fav) {
    if (fav) {
      return 'Your favorite Poke !!';
    } else {
      return 'Pokedex displays all Poke !!';
    }
  }

  String menuTitle(bool fav) {
    if (fav) {
      return 'Switch to all Poke';
    } else {
      return 'Switch to your favorite Poke';
    }
  }

  String menuSubtitle(bool fav) {
    if (fav) {
      return 'すべてのポケモンを表示';
    } else {
      return 'お気に入りに登録したポケモンのみ表示';
    }
  }

  String menuGridTitle(bool grid) {
    if (grid) {
      return 'Switch to list display';
    } else {
      return 'Switch to grid display';
    }
  }

  String menuGridSubtitle(bool grid) {
    if (grid) {
      return 'ポケモンをリスト表示';
    } else {
      return 'ポケモンをグリッド表示';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Center(
          child: Column(children: [
        Container(
            height: 5,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.background,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Text(
            mainText(favMode),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz),
          title: Text(
            menuTitle(favMode),
          ),
          subtitle: Text(
            menuSubtitle(favMode),
          ),
          onTap: () {
            changeFavMode(favMode);
            Navigator.pop(context, true);
          },
        ),
        ListTile(
          leading: const Icon(Icons.grid_3x3),
          title: Text(
            menuGridTitle(gridMode),
          ),
          subtitle: Text(
            menuGridSubtitle(gridMode),
          ),
          onTap: () {
            changeGridMode(gridMode);
            Navigator.pop(context);
          },
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          ),
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ])),
    );
  }
}
