class TransactionsModel {
  String? status;
  String? createdAt;
  String? reference;
  num? amount;
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? source;

  TransactionsModel({
    this.accountName,
    this.accountNumber,
    this.amount,
    this.createdAt,
    this.source,
    this.status,
    this.bankName,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
        accountName: json["account name"],
        accountNumber: json["account number"],
        amount: json["amount"],
        createdAt: json["created at"],
        source: json["source"],
        status: json["status"],
        bankName: json["bank name"],
      );
}
