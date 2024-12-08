import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freedom/handlers/fetchSongs.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({super.key});

  @override
  State<SearchSongScreen> createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  final TextEditingController _search = TextEditingController();

  FetchSongs fetchSongs = FetchSongs();

  List<dynamic> _songs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Search Songs",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for a song...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: GestureDetector(
                    onTap: () async {
                      log(_search.text.trim());
                      List<dynamic> songs = await fetchSongs
                          .fetchSongsFromQuery(_search.text.trim());
                      log(songs[0].toString());
                      setState(() {
                        _songs = songs;
                      });
                    },
                    child: Icon(Icons.search, color: Colors.grey[500])),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Recently Played",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // Recently Played Songs
            Expanded(
              child: ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  var currentSong = _songs[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(currentSong['album']
                              ['cover_big']), // Replace with your image asset
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      currentSong['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      currentSong['artist']['name'],
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    trailing: IconButton(
                      icon:
                          Icon(Icons.favorite_border, color: Colors.grey[500]),
                      onPressed: () {
                        // Handle favorite action
                      },
                    ),
                    onTap: () {
                      log(currentSong.toString());
                      try {
                        Navigator.pushNamed(context, "/play",
                            arguments: {
                              "imageUri": currentSong['album']['cover_big'].toString(),
                              "artistName": currentSong['artist']['name'].toString(),
                              "songName": currentSong['title'].toString(),
                              "songUri": currentSong['preview'].toString(),
                              "duration": currentSong['duration'].toString(),
                            });
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
