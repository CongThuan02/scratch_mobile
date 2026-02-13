import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/constants.dart';

class ScratchWebViewScreen extends StatefulWidget {
  final String url;

  const ScratchWebViewScreen({super.key, this.url = 'https://scratch.mit.edu/projects/editor/?tutorial=getStarted'});

  @override
  State<ScratchWebViewScreen> createState() => _ScratchWebViewScreenState();
}

class _ScratchWebViewScreenState extends State<ScratchWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Force Landscape for better Scratch experience
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {},
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                _injectMobileCss();
              },
              onWebResourceError: (WebResourceError error) {},
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void _injectMobileCss() {
    // Hide standard Scratch headers to save space and reduce clutter on mobile
    const css = """
      // Hide the top menu bar (File, Edit, etc.)
      document.getElementsByClassName('gui_menu-bar-position_3U-tc')[0].style.display = 'none';
      
      // Remove padding around stage to maximize space
      document.getElementsByClassName('gui_stage-and-target-wrapper_69KBf')[0].style.paddingRight = '0';
      
      // Optional: Adjust zoom or scale if needed
      // document.body.style.zoom = "0.8";
    """;

    // Attempt to run CSS injection. Note: Class names might change in Scratch updates.
    // This is a best-effort optimization.
    _controller.runJavaScript(css).catchError((e) => debugPrint('CSS Injection failed: $e'));
  }

  @override
  void dispose() {
    // Restore Portrait layout when leaving the screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(child: WebViewWidget(controller: _controller)),
          if (_isLoading) Center(child: CircularProgressIndicator(color: AppColors.primary)),
          // Floating Back Button
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.primary.withOpacity(0.8),
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
