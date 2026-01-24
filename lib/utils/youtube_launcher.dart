import 'package:url_launcher/url_launcher.dart';

Future<void> openYoutubeVideo(String videoId) async {
  final appUrl = Uri.parse("vnd.youtube:$videoId");
  final webUrl = Uri.parse("https://www.youtube.com/watch?v=$videoId");

  if (await canLaunchUrl(appUrl)) {
    await launchUrl(appUrl, mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrl(webUrl)) {
    await launchUrl(webUrl, mode: LaunchMode.externalApplication);
  } else {
    throw Exception("Không thể mở YouTube");
  }
}
