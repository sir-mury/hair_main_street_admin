import 'package:cloud_firestore/cloud_firestore.dart';

class CancellationRequest {
  String? userID;
  String? requestID;
  String? orderID;
  String? reason;
  String? cancellationStatus;
  String? cancellationAccount;
  String? cancellationBankCode;
  num? cancellationAmount;
  Timestamp? createdAt;

  CancellationRequest({
    this.orderID,
    this.reason,
    this.cancellationStatus,
    this.cancellationAmount,
    this.requestID,
    this.cancellationAccount,
    this.cancellationBankCode,
    this.userID,
    this.createdAt,
  });

  factory CancellationRequest.fromData(Map<String, dynamic> data) {
    return CancellationRequest(
        orderID: data['orderID'] ?? '',
        reason: data['reason'] ?? '',
        requestID: data['requestID'],
        cancellationAmount: data['cancellation amount'] ?? 0,
        cancellationStatus: data['cancellation status'],
        userID: data["userID"],
        cancellationAccount: data['cancellation account'],
        cancellationBankCode: data['cancellation bank_code'],
        createdAt: data["created at"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'requestID': requestID,
      'cancellation amount': cancellationAmount,
      'reason': reason,
      'cancellation status': cancellationStatus,
      'userID': userID,
      'cancellation account': cancellationAccount,
      'cancellation bank_code': cancellationBankCode,
      'created at': createdAt,
    };
  }
}
