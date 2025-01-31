class MonnifyBalanceModel {
  num? availableBalance;
  num? ledgerBalance;

  MonnifyBalanceModel({
    this.availableBalance,
    this.ledgerBalance,
  });

  factory MonnifyBalanceModel.fromJson(Map<String, dynamic> json) =>
      MonnifyBalanceModel(
        availableBalance: json["availableBalance"],
        ledgerBalance: json["ledgerBalance"],
      );

  Map<String, dynamic> toJson() => {
        "availableBalance": availableBalance,
        "ledgerBalance": ledgerBalance,
      };
}

class PaystackBalanceModel {
  num? balance;
  String? currency;

  PaystackBalanceModel({
    this.balance,
    this.currency,
  });

  factory PaystackBalanceModel.fromJson(Map<String, dynamic> json) =>
      PaystackBalanceModel(
        balance: json["balance"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
      };
}
