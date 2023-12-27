import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/pokemon.dart';
import './const/pokeapi.dart';
import './poke_list_item.dart';
import 'models/favorite.dart';
import './poke_grid_item.dart';
import './modal_bottom_sheet.dart';

class PokeList extends StatefulWidget {
  const PokeList({super.key});

  @override
  State<PokeList> createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30; // クラス内のconst int宣言はstaticを付けないとエラー
  int _currentPage = 1;
  bool isFavoriteMode = false;
  bool isGridMode = true;

  //  表示しているpokemonの数を算出する関数
  int itemCount(int favsCount, int page) {
    int ret = page * pageSize;
    if (isFavoriteMode && ret > favsCount) {
      ret = favsCount;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(List<Favorite> favs, int index) {
    int ret = index + 1;
    if (isFavoriteMode) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  void changeFavMode(bool currentMode) {
    setState(() => isFavoriteMode = !currentMode);
  }

  void changeGridMode(bool currentMode) {
    setState(() => isGridMode = !isGridMode);
  }

  bool isLastPage(int favsCount, int page) {
    if (isFavoriteMode) {
      if (page * pageSize < favsCount) {
        return false;
      }
      return true;
    } else {
      if (page * pageSize < pokeMaxId) {
        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, value) => Column(children: [
        Container(
          height: 24,
          alignment: Alignment.topRight,
          child: IconButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return ViewModeBottomSheet(
                      favMode: isFavoriteMode,
                      changeFavMode: changeFavMode,
                      gridMode: isGridMode,
                      changeGridMode: changeGridMode,
                    );
                  });
            },
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Consumer<PokemonsNotifier>(builder: (context, pokes, child) {
            if (itemCount(favs.favs.length, _currentPage) == 0) {
              return const Text(
                'No data',
                style: TextStyle(fontSize: 20),
              );
            } else {
              if (isGridMode) {
                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                  itemBuilder: (context, index) {
                    if (index == itemCount(favs.favs.length, _currentPage)) {
                      return OutlinedButton(
                        onPressed: isLastPage(favs.favs.length, _currentPage)
                            ? null // nullでボタンを無効化
                            : () => {setState(() => _currentPage++)},
                        child: const Text('more'),
                      );
                    } else {
                      return PokeGridItem(
                        poke: pokes.byId(itemId(favs.favs, index)),
                      );
                    }
                  },
                );
              } else {
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  itemCount: itemCount(favs.favs.length, _currentPage) +
                      1, // pokemonの表示数 + 1にmoreボタンを表示
                  itemBuilder: (context, index) {
                    if (index == itemCount(favs.favs.length, _currentPage)) {
                      return OutlinedButton(
                        onPressed: isLastPage(favs.favs.length, _currentPage)
                            ? null // nullでボタンを無効化
                            : () => {setState(() => _currentPage++)},
                        child: const Text('more'),
                      );
                    } else {
                      return PokeListItem(
                        poke: pokes.byId(itemId(favs.favs, index)),
                      );
                    }
                  },
                );
              }
            }
          }),
        ),
      ]),
    );
  }
}
