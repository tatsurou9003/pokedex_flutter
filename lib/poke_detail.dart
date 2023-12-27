import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_flutter/models/favorite.dart';
import './models/pokemon.dart';
import './const/pokeapi.dart';

class PokeDetail extends StatelessWidget {
  const PokeDetail({Key? key, required this.poke}) : super(key: key);
  final Pokemon poke;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Scaffold(
        body: Container(
          color: (pokeTypeColors[poke.types.first] ?? Colors.grey)
              .withOpacity(0.5),
          child: SafeArea(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                trailing: IconButton(
                  icon: favs.isExist(poke.id)
                      ? const Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                        )
                      : const Icon(Icons.star_outline),
                  onPressed: () {
                    favs.toggle(Favorite(pokeId: poke.id));
                  },
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: CachedNetworkImage(
                      imageUrl: poke.imageUrl,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'No.${poke.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                poke.name,
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: poke.types
                    .map((type) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Chip(
                            backgroundColor:
                                pokeTypeColors[type] ?? Colors.grey,
                            shape: const StadiumBorder(),
                            label: Text(
                              type,
                              style: TextStyle(
                                  color: (pokeTypeColors[type] ?? Colors.grey)
                                              .computeLuminance() > // 明るいときに黒字、暗い時に白字にする
                                          0.5
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const Spacer()
            ]),
          ),
        ),
      ),
    );
  }
}
