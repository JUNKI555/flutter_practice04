import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_playout/multiaudio/HLSManifestLanguage.dart';
import 'package:flutter_playout/multiaudio/MultiAudioSupport.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';

import 'getManifestLanguages.dart';

class VideoPlayout extends StatefulWidget {
  final PlayerState desiredState;
  final bool showPlayerControls;

  const VideoPlayout({Key key, this.desiredState, this.showPlayerControls})
      : super(key: key);

  @override
  _VideoPlayoutState createState() => _VideoPlayoutState();
}

class _VideoPlayoutState extends State<VideoPlayout>
    with PlayerObserver, MultiAudioSupport {
  final String _url =
      "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8";
  List<HLSManifestLanguage> _hlsLanguages = List<HLSManifestLanguage>();

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getHLSManifestLanguages);
  }

  Future<void> _getHLSManifestLanguages() async {
    if (!Platform.isIOS && _url != null && _url.isNotEmpty) {
      _hlsLanguages = await getManifestLanguages(_url);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              /* player */
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Video(
                  autoPlay: true,
                  showControls: widget.showPlayerControls,
                  title: "MTA International",
                  subtitle: "Reaching The Corners Of The Earth",
                  preferredAudioLanguage: "eng",
                  isLiveStream: true,
                  position: 0,
                  url: _url,
                  onViewCreated: _onViewCreated,
                  desiredState: widget.desiredState,
                  preferredTextLanguage: "en",
                ),
              ),
              Positioned(
                top: 40.0,
                left: 5.0,
                child: AnimatedOpacity(
                    opacity: _isPlaying ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 200),
                    child: new Icon(Icons.fit_screen)),
              ),
            ],
          ),
          /* multi language menu */
          _hlsLanguages.length < 2 && !Platform.isIOS
              ? Container()
              : Container(
                  child: Row(
                    children: _hlsLanguages
                        .map((e) => MaterialButton(
                              child: Text(
                                e.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () {
                                setPreferredAudioLanguage(e.code);
                              },
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  void _onViewCreated(int viewId) {
    listenForVideoPlayerEvents(viewId);
    enableMultiAudioSupport(viewId);
  }

  @override
  void onPlay() {
    super.onPlay();

    setState(() {
      _isPlaying = true;
    });
  }

  @override
  void onPause() {
    super.onPause();

    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void onComplete() {
    // TODO: implement onComplete
    super.onComplete();
  }

  @override
  void onTime(int position) {
    // TODO: implement onTime
    super.onTime(position);
  }

  @override
  void onSeek(int position, double offset) {
    // TODO: implement onSeek
    super.onSeek(position, offset);
  }

  @override
  void onDuration(int duration) {
    // TODO: implement onDuration
    super.onDuration(duration);
  }

  @override
  void onError(String error) {
    // TODO: implement onError
    super.onError(error);
  }
}
