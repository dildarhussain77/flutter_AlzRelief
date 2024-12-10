import 'package:alzrelief/screens/alzheimer_user/home/Activity_Manager/music_playlist/favourite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'music_player_page.dart';

class MusicPlaylistPage extends StatefulWidget {
  const MusicPlaylistPage({super.key});

  @override
  _MusicPlaylistPageState createState() => _MusicPlaylistPageState();
}

class _MusicPlaylistPageState extends State<MusicPlaylistPage> {
  final List<String> _favoriteSongs = [];
  final List<Map<String, dynamic>> _musicPlaylists = [
    {
      'name': 'Relaxing Rhythms',
      'songs': ['assets/music/quran.mp3','assets/music/music1.mp3', 'assets/music/music2.mp3','assets/music/music3.mp3', 'assets/music/music4.mp3', 'assets/music/music5.mp3'],
    },   
  ];

  // Fetch favorite songs from Firestore
  Future<void> _fetchFavoriteSongs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final favoritesRef = FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('favorites');

      final snapshot = await favoritesRef.get();
      setState(() {
        _favoriteSongs.clear();
        for (var doc in snapshot.docs) {
          var songPath = doc['songPath'];
          _favoriteSongs.add(songPath);
        }
      });
    }
  }

  // Add a song to the favorites in Firestore
  Future<void> _addToFavorites(String songPath) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final favoritesRef = FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('favorites');

      // Add song to the 'favorites' subcollection
      await favoritesRef.add({
        'songPath': songPath,
        'addedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _favoriteSongs.add(songPath);
      });
    }
  }

  // Remove a song from the favorites in Firestore
  Future<void> _removeFromFavorites(String songPath) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final favoritesRef = FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('favorites');

      final snapshot = await favoritesRef.where('songPath', isEqualTo: songPath).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _favoriteSongs.remove(songPath);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFavoriteSongs();  // Fetch favorites on page load
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      "Music PLaylist", style: TextStyle(
                        color: Colors.white, fontSize: 24, 
                        fontWeight: FontWeight.bold),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/music.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(
                              favoriteSongs: _favoriteSongs,
                              removeFromFavorites: _removeFromFavorites,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _musicPlaylists.length,
                          itemBuilder: (context, index) {
                            var playlist = _musicPlaylists[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(95, 37, 133, 1.0),
                                  ),
                                ),
                                SizedBox(height: 10),
                                for (var song in playlist['songs'])
                                  Card(
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.music_note, // Icon for the diary
                                        color: Colors.blue[400], // You can change the color to match your design
                                      ),
                                      title: Text(
                                        song.split('/').last,
                                        style: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          _favoriteSongs.contains(song)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red[400],
                                        ),
                                        onPressed: () {
                                          if (_favoriteSongs.contains(song)) {
                                            _removeFromFavorites(song);
                                          } else {
                                            _addToFavorites(song);
                                          }
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MusicPlayerPage(
                                              playlistName: playlist['name'],
                                              songs: playlist['songs'],
                                               initialIndex: playlist['songs'].indexOf(song), // Pass the correct song index
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
