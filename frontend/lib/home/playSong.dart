import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlaySong extends StatefulWidget {
  const PlaySong(
      {super.key,
      required this.imageUri,
      required this.artistName,
      required this.songName,
      required this.songUri,
      required this.duration});

  final String imageUri;
  final String artistName;
  final String songName;
  final String songUri;
  final int duration;

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  late AudioPlayer _audioPlayer;
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    setState(() {
      _totalDuration = Duration(seconds: widget.duration);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  void _seek(double value) async {
    final position = Duration(seconds: value.toInt());
    await _audioPlayer.seek(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.songUri.toString()));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1),
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: NetworkImage(widget.imageUri),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Song Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.songName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            // Artist Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.artistName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Play Button

            Slider(
              activeColor: Colors.white,
              value: _currentPosition.inSeconds.toDouble(),
              max: _totalDuration.inSeconds.toDouble(),
              onChanged: (value) {
                _seek(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_currentPosition)),
                  Text(_formatDuration(_totalDuration)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.stop),
                  iconSize: 50,
                  onPressed: _stop,
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                  onPressed: _playPause,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
