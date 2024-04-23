import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    super.key,
    required this.image,
    required this.url,
  });

  final Widget image;
  final String url;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  late bool _isHovered;

  @override
  void initState() {
    _isHovered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _isHovered ? 0.8 : 1,
      child: MouseRegion(
        onExit: _onExit,
        onEnter: _onEnter,
        cursor: SystemMouseCursors.click,
        child: Semantics(
          link: true,
          label: widget.url,
          enabled: true,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: () {
              _goToLink(widget.url);
            },
            child: widget.image,
          ),
        ),
      ),
    );
  }

  void _goToLink(String link) {
    launchUrl(Uri.parse(link));
  }

  void _onEnter(_) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(_) {
    setState(() {
      _isHovered = false;
    });
  }
}
