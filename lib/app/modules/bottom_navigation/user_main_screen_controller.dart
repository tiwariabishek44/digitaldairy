import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitaldairy/app/modules/milk_chart.dart';
import 'package:digitaldairy/app/modules/notice/notice.dart';
import 'package:digitaldairy/app/modules/home/home.dart';
import 'package:digitaldairy/app/modules/record/record.dart';
import 'package:digitaldairy/app/modules/weather/weather.dart';

class UserMainScreenController extends GetxController {
  // Current tab index
  var currentIndex = 0.obs;

  // Page storage bucket for maintaining scroll position
  PageStorageBucket bucket = PageStorageBucket();

  // List of pages - Updated with 4 tabs
  List<Widget> pages = [
    // WeatherScreen(), // Settings/Profile tab
    Home(),
    CollectionRecordsPage(),
    NoticePage(),
    MilkAnalysisPage(),
  ];

  // Current screen getter
  Widget get currentScreen => pages[currentIndex.value];

  // Change tab index
  void changeTabIndex(int index) {
    if (index >= 0 && index < pages.length) {
      currentIndex.value = index;
    }
  }
}
