import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YouTubeMusic {
  final String videoId;
  final String title;
  final String thumbnail;

  YouTubeMusic({
    required this.videoId,
    required this.title,
    required this.thumbnail,
  });
}

class YouTubeService {
  static Future<List<YouTubeMusic>> searchMusic(String keyword) async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];
    print("DEBUG YT KEY = $apiKey");

    // final apiKey = dotenv.env['YOUTUBE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("Missing YOUTUBE_API_KEY");
    }

    final query = Uri.encodeComponent(keyword);
    final url =
        "https://www.googleapis.com/youtube/v3/search"
        "?part=snippet"
        "&type=video"
        "&videoCategoryId=10"
        "&maxResults=5"
        "&q=$query"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("YouTube API error: ${response.body}");
    }

    final data = jsonDecode(response.body);

    return (data['items'] as List).map((item) {
      return YouTubeMusic(
        videoId: item['id']['videoId'],
        title: item['snippet']['title'],
        thumbnail: item['snippet']['thumbnails']['high']['url'],
      );
    }).toList();
  }
}
