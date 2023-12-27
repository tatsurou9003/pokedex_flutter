import 'package:flutter/material.dart';
import '../db/favorite.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<Favorite> favs = [];

  FavoriteNotifier() {
    syncDb();
  }

  List<Favorite> get fav => favs;

  // dbからリストをreadしてローカルのfavsに同期
  void syncDb() async {
    FavoritesDb.read().then((value) => favs
      ..clear()
      ..addAll(value));
    notifyListeners();
  }

  void add(Favorite fav) async {
    await FavoritesDb.create(fav);
    syncDb();
  }

  void delete(int id) async {
    await FavoritesDb.delete(id);
    syncDb();
  }

  bool isExist(int id) {
    // ListのindexWhereメソッドは、条件に合致した最初の要素のindexを返す。合致しなければ-1を返す。
    if (favs.indexWhere((element) => element.pokeId == id) < 0) {
      return false;
    }
    return true;
  }

  void toggle(Favorite fav) {
    if (isExist(fav.pokeId)) {
      delete(fav.pokeId);
    } else {
      add(fav);
    }
  }
}

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });

  Map<String, int> toMap() {
    return {'id': pokeId};
  }
}
