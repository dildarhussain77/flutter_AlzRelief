import 'package:flutter/material.dart';
import 'music_player_page.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteSongs;
  final Function(String) removeFromFavorites;

  const FavoritesScreen({super.key, 
    required this.favoriteSongs,
    required this.removeFromFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back arrow here
        ),
      ),
      body: favoriteSongs.isEmpty
          ? Center(
              child: Text(
                'No favorite songs yet!',
                style: TextStyle(fontSize: 18, color: Color.fromRGBO(95, 37, 133, 1.0)),
              ),
            )
          : ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                var song = favoriteSongs[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      song.split('/').last, // Display only the song name
                      style: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                      onPressed: () {
                        removeFromFavorites(song);
                      },
                    ),
                    onTap: () {
                      // Navigate to the MusicPlayerPage to play the selected song
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPlayerPage(
                            playlistName: "Favorites",
                            songs: favoriteSongs, // Pass the favorites list
                            initialIndex: index, // Start from the tapped song
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
