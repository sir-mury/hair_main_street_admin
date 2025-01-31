import 'package:cloud_firestore/cloud_firestore.dart';

class RefundRequest {
  String? requestID;
  String? orderID;
  String? reason;
  String? addedDetails;
  String? refundStatus;
  String? userID;
  String? refundAccountNumber;
  String? refundBankCode;
  num? refundAmount;
  Timestamp? createdAt;

  RefundRequest({
    this.orderID,
    this.reason,
    this.addedDetails,
    this.refundAmount,
    this.refundStatus,
    this.requestID,
    this.userID,
    this.refundAccountNumber,
    this.refundBankCode,
    this.createdAt,
  });

  factory RefundRequest.fromData(Map<String, dynamic> data) {
    return RefundRequest(
      orderID: data['orderID'] ?? '',
      reason: data['reason'] ?? '',
      requestID: data['requestID'],
      addedDetails: data['added details'] ?? '',
      refundAmount: data['refund amount'] ?? 0,
      refundStatus: data['refund status'] ?? '',
      userID: data['userId'],
      refundAccountNumber: data['refund account'] ?? '',
      refundBankCode: data['refund bank_code'] ?? '',
      createdAt: data['created at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderID': orderID,
      'requestID': requestID,
      'reason': reason,
      'added details': addedDetails,
      'refund status': refundStatus,
      'userID': userID,
      'refund amount': refundAmount,
      'refund bank_code': refundBankCode,
      'refund account': refundAccountNumber,
      'created at': createdAt,
    };
  }
}
