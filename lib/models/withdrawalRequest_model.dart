import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawalRequest {
  String? userId;
  num? withdrawalAmount;
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? status;
  Timestamp? timestamp;

  WithdrawalRequest({
    this.withdrawalAmount,
    this.accountName,
    this.timestamp,
    this.accountNumber,
    this.bankName,
    this.status,
    this.userId,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      accountName: json["account name"],
      accountNumber: json["account number"],
      timestamp: json["timestamp"],
      bankName: json["bank name"],
      status: json["status"],
      userId: json['userID'],
      withdrawalAmount: json['withdrawal amount'],
    );
  }

  Map<String, dynamic> toJson() => {
        "account name": accountName,
        "account number": accountNumber,
        "timestamp": timestamp,
        "bank name": bankName,
        "status": status,
        "userID": userId,
        "withdrawal amount": withdrawalAmount,
      };
}
