class AdminVariables {
  num? convinienceFee;
  num? installmentDuration;
  List<String>? categories;
  num? expiredFee;

  AdminVariables({
    this.categories,
    this.convinienceFee,
    this.expiredFee,
    this.installmentDuration,
  });

  factory AdminVariables.fromJson(Map<String, dynamic> json) => AdminVariables(
        categories: List.from(json["categories"], growable: true),
        convinienceFee: json["convenience fee"],
        expiredFee: json["expired fee"],
        installmentDuration: json["installment duration"],
      );

  Map<String, dynamic> toJson() => {
        "categories": categories!.toList(),
        "convenience fee": convinienceFee,
        "expired fee": expiredFee,
        "installment duration": installmentDuration,
      };
}
