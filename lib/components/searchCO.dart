import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["ucode"],
      name: json["uname"],
    );
  }

  static List<UserModel>? fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}

class ArbitrarySuggestionType {
  num stars;
  String name, eid;

  ArbitrarySuggestionType(this.stars, this.name, this.eid);

  userFilterByCreationDate(String? filter) {}
}

class SearchEmployee extends StatefulWidget {
  var selected = [];
  dynamic itemSubmitted;
  dynamic itemBuilder;
  dynamic itemSorter;
  dynamic suggestions;
  dynamic decoration;
  dynamic textSubmitted;
  dynamic searchControllerTextFormField;
  dynamic textChanged;

  SearchEmployee({
    required this.selected,
    this.itemSubmitted,
    this.itemBuilder,
    this.itemSorter,
    this.decoration,
    this.suggestions,
    this.textSubmitted,
    this.searchControllerTextFormField,
    this.textChanged,
  });

  @override
  State<StatefulWidget> createState() => _SecondPageState();
}

class _SecondPageState extends State<SearchEmployee> {
  bool _isloading = false;

  GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> key =
      new GlobalKey();

  late AutoCompleteTextField<ArbitrarySuggestionType> textField;

  double sizeCircle = 10;

  bool _isLoadingClearSelected = false;
  bool selectEmployeeColor = false;

  //FUNCTUION FOR CHANGE COLOR

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoCompleteTextField<ArbitrarySuggestionType>(
          controller: widget.searchControllerTextFormField,
          decoration: widget.decoration,
          itemSubmitted: widget.itemSubmitted,
          key: key,
          textChanged: widget.textChanged,
          suggestions: widget.suggestions,
          itemBuilder: widget.itemBuilder,
          itemSorter: widget.itemSorter,
          submitOnSuggestionTap: true,
          textSubmitted: widget.textSubmitted,
          itemFilter: (suggestion, input) {
            if (input.length > 3) {
              // searchControllerTextFormField.text = input.toLowerCase();
              return suggestion.name
                  .toLowerCase()
                  .startsWith(input.toLowerCase());
            } else {
              return suggestion.name
                  .toLowerCase()
                  .startsWith(input.toLowerCase());
            }
          },
        ),
      ],
    );
  }
}
