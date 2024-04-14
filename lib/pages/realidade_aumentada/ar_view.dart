import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ArView extends StatefulWidget {
  const ArView({super.key});

  @override
  State<ArView> createState() => _ArViewState();
}

class _ArViewState extends State<ArView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    Permission.camera.request();

    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params,
            onPermissionRequest: (request) {
      if (request.types.contains(WebViewPermissionResourceType.microphone)) {
        request.deny();
      } else {
        request.grant();
      }
    });

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Color.fromARGB(0, 255, 255, 255))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (message) => SnackBar(
          content: Container(
            child: Text(
              message.message,
            ),
          ),
        ),
      )
      ..loadRequest(Uri.parse(
          'https://ar-js-org.github.io/.github/profile/aframe/examples/marker-based/basic.html'));
    //..loadFlutterAsset('assets/ar/arjs.html');

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebViewWidget(controller: _controller),
      height: MediaQuery.of(context).size.height,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller
        .runJavaScript("""
          navigator.mediaDevices.getUserMedia({video: true, audio: false})
            .then(mediaStream => {
              const stream = mediaStream;
              const tracks = stream.getTracks();

              tracks.forEach(track => track.stop())
            });""")
        .then(
          (value) => super.dispose(),
        )
        .catchError(
          (error) => {
            SnackBar(
              content: Text('Erro: ' + error),
            )
          },
        );
  }
}
