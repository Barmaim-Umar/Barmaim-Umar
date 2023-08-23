// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

import 'package:pfc/utility/Widgets/AutoCompleteLocationModel/autocompleteprediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutoCompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status,this.predictions});
  factory PlaceAutocompleteResponse.fromJson(Map<String,dynamic>json){
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null? json['predictions'].map<AutoCompletePrediction>((json) => AutoCompletePrediction.fromJson(json)).toList():null
    );
  }
  static PlaceAutocompleteResponse parseAutocompleteResult(String responseBody){
    final parsed = json.decode(responseBody).cast<String , dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}