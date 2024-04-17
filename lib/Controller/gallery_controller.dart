import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Model/photo_model.dart';

class PhotoController extends GetxController {

  final photoData = <PhotoModel>[].obs;

  bool isLoadingPage = false;
  final scrollController = ScrollController();

  int pageNumber = 1;
  final int perPageLength = 30;

  @override
  void onInit() {
    super.onInit();
    fetchAllPhotoDataApi();
    scrollController.addListener(scrollListenerMethod);
  }

  void scrollListenerMethod() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLoadingPage) {
        return;
      }
      fetchAllPhotoDataApi();
    }
  }

  Future<void> fetchAllPhotoDataApi() async {
    const String apiKey = '43434663-d265904f2024d757430d1556d';
    String url =
        'https://pixabay.com/api/?key=$apiKey&q=yellow+fllower&page=$pageNumber&per_page=$perPageLength';

    isLoadingPage = true;

    final response = await http.get(Uri.parse(url));

    isLoadingPage = false;

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['hits'];
      final imageList =
          List<PhotoModel>.from(data.map((e) => PhotoModel.fromJson(e)));
      photoData.addAll(imageList);
      pageNumber++;
    } else {
      throw Exception('Failed to load image data');
    }
  }
}
