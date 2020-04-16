import 'dart:convert';
import 'dart:html';

Future<ImageElement> fetchImage(url) async {
  final request = await HttpRequest.request(url, responseType: 'blob');
  final image = ImageElement(src: Url.createObjectUrl(request.response));

  await image.onLoad.first;

  return image;
}

Future<Map> fetchJson(url) async {
  final jsonString = await HttpRequest.getString(url);
  final jsonData = json.decode(jsonString) as Map;

  return jsonData;
}
