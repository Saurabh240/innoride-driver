import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovoride_driver/data/model/location/selected_location_info.dart';
import 'package:ovoride_driver/data/repo/dashboard/dashboard_repo.dart';

class InterCityController extends GetxController {
  DashBoardRepo repo;
  InterCityController({required this.repo});

  bool isLoading = true;
  double mainAmount = 0;
  String currentAddress = "";
  TextEditingController amountController = TextEditingController();

  Future<void> initialData({bool shouldLoad = true}) async {
    mainAmount = 0;
    isLoading = shouldLoad ? true : false;
    update();
    Future.delayed(const Duration(seconds: 3));
    isLoading = false;
    update();
  }

  updateMainAmount(double amount) {
    mainAmount = amount;

    update();
  }

  addMainAmount(double amount) {
    mainAmount += amount;
    update();
  }

  removeMainAmount(double amount) {
    if (mainAmount > 0) {
      mainAmount -= amount;
      update();
    }
  }

  List<SelectedLocationInfo> selectedLocations = [];

  SelectedLocationInfo? getSelectedLocationInfoAtIndex(int index) {
    if (index >= 0 && index < selectedLocations.length) {
      return selectedLocations[index];
    } else {
      return null;
    }
  }

  void addLocationAtIndex(
      SelectedLocationInfo selectedLocationInfo, int index) {
    SelectedLocationInfo newLocation = selectedLocationInfo;

    if (selectedLocations.length > index && index >= 0) {
      selectedLocations[index] = newLocation;
    } else {
      selectedLocations.add(newLocation);
    }
    update();
  }
}
