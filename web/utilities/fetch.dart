import 'dart:convert';
import 'dart:html';

Future<ImageElement> fetchImage(String url) async {
  final request = await HttpRequest.request(url, responseType: 'blob');
  final image = ImageElement(src: Url.createObjectUrl(request.response));

  await image.onLoad.first;

  return image;
}

Future fetchString(String url) async => HttpRequest.getString(url);

Future<Map> fetchJson(String url) async {
  final jsonString = await fetchString(url);
  final jsonData = json.decode(jsonString) as Map;

  return jsonData;
}

Future<Map> fetchAllAs(Map<String, Future> toFetch) async {
  final response = await Future.wait(toFetch.values);
  final result = {};

  for (var i = 0; i < toFetch.length; i++) {
    result[toFetch.keys.elementAt(i)] = response.elementAt(i);
  }

  return result;
}
