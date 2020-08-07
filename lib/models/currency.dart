import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {
    Currency();

    String curcode;
    String curname;
    String curdes;
    String u1;
    String u2;
    String u3;
    String u4;
    String u5;
    String loan;
    
    factory Currency.fromJson(Map<String,dynamic> json) => _$CurrencyFromJson(json);
    Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
