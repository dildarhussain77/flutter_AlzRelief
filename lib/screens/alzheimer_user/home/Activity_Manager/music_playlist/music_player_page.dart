import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerPage extends StatefulWidget {
  final String playlistName;
  final List<String> songs; // List of song asset paths
  final int initialIndex;

  const MusicPlayerPage({super.key, 
    required this.playlistName,
    required this.songs,
    this.initialIndex = 0,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _currentPosition = Duration();
  Duration _totalDuration = Duration();
  late Stream<Duration> _positionStream;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _loadCurrentSong();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _loadCurrentSong() async {
    try {
      await _audioPlayer.setAsset(widget.songs[_currentIndex]);
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _totalDuration = duration ?? Duration.zero;
        });
      });
    } catch (e) {
      print("Error loading song: $e");
    }
  }

  void _playMusic() async {
    try {
      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _isPaused = false;
      });
    } catch (e) {
      print("Error playing music: $e");
    }
  }

  void _pauseMusic() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
        _isPaused = true;
      });
    } catch (e) {
      print("Error pausing music: $e");
    }
  }

  void _stopMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    } catch (e) {
      print("Error stopping music: $e");
    }
  }

  void _nextSong() {
    if (_currentIndex < widget.songs.length - 1) {
      _currentIndex++;
      _loadCurrentSong();
      _playMusic();
    }
  }

  void _previousSong() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _loadCurrentSong();
      _playMusic();
    }
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName, style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back arrow here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display image of music with decoration
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Rounded corners for image
                  child: Image.asset(
                    'assets/images/music.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between image and song name

            // Display current song name
            Text(
              widget.songs[_currentIndex].split('/').last, // Extract song name from asset path
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Display song time progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_formatDuration(_currentPosition), style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: _currentPosition.inSeconds.toDouble(),
                    min: 0,
                    max: _totalDuration.inSeconds.toDouble(),
                    onChanged: _seekTo,
                    activeColor: Color.fromRGBO(95, 37, 133, 1.0),
                    inactiveColor: Colors.grey,
                  ),
                ),
                Text(_formatDuration(_totalDuration), style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 30),

            // Play/Pause Button
            IconButton(
              iconSize: 60,
              icon: Icon(
                _isPlaying
                    ? Icons.pause_circle_filled
                    : (_isPaused ? Icons.play_circle_filled : Icons.play_circle_outline),
                color: Color.fromRGBO(95, 37, 133, 1.0),
              ),
              onPressed: _isPlaying ? _pauseMusic : _playMusic,
            ),
            SizedBox(height: 20),

            // Stop Button
            IconButton(
              iconSize: 60,
              icon: Icon(Icons.stop_circle, color: Colors.red[400]),
              onPressed: _stopMusic,
            ),
            SizedBox(height: 30),

            // Next and Previous Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_previous, color: Color.fromRGBO(95, 37, 133, 1.0)),
                  onPressed: _previousSong,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_next, color: Color.fromRGBO(95, 37, 133, 1.0)),
                  onPressed: _nextSong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
