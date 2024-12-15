class MusicPlaylist {
  final String name;
  final List<String> songs; // List of song names or asset paths

  MusicPlaylist({
    required this.name,
    required this.songs,
  });

  // No need to convert to/from Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'songs': songs,
    };
  }

  factory MusicPlaylist.fromMap(Map<String, dynamic> map) {
    return MusicPlaylist(
      name: map['name'] ?? '',
      songs: List<String>.from(map['songs'] ?? []),
    );
  }
}
