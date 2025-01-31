import 'dart:convert';
import 'package:hair_main_street_admin/models/balance_model.dart';
import 'package:hair_main_street_admin/models/transactions_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  String baseUrlMonnify = dotenv.env["DEBUG"] == "true"
      ? "https://sandbox.monnify.com"
      : "https://api.monnify.com";
  String baseUrlPaystack = "https://api.paystack.co";
  String? paystackSecretKey = dotenv.env["PAYSTACK_SECRET_KEY"];
  String? paystackPublicKey = dotenv.env["PAYSTACK_PUBLIC_KEY"];
  String? callbackUrl = dotenv.env["CALLBACK_URL"];
  String? monnifySecretKey = dotenv.env["MONNIFY_SECRET_KEY"];
  String? monnifyApiKey = dotenv.env["MONNIFY_API_KEY"];
  String? walletAccountNumber = dotenv.env["WALLET_ACCOUNT_NUMBER"];
  String? accessToken;

  // Singleton instance
  static final ApiService _instance = ApiService._();

  // Private constructor
  ApiService._() {
    _init();
  }

  // Init function
  void _init() async {
    await generateMonnifyToken();
    print("ApiService initialized!");
  }

  // Public accessor for the singleton instance
  static ApiService get instance => _instance;

  //generate base64 string
  String generateBase64String() {
    List<int> base64bytes = utf8.encode("$monnifyApiKey:$monnifySecretKey");
    String base64String = base64.encode(base64bytes);
    return base64String;
  }

  //generate and obtain base64 key for monnify api
  Future<void> generateMonnifyToken() async {
    String base64String = generateBase64String();
    http.Response response = await http.post(
      Uri.parse("$baseUrlMonnify/api/v1/auth/login"),
      headers: {"Authorization": "Basic $base64String"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      accessToken = body["responseBody"]["accessToken"];
    } else {
      throw Exception("Token not gotten");
    }
  }

  //helper function to initiate paystack transfer recipient
  Future<String> initiatePaystackTransferRecipient(
    String bankCode,
    String accountName,
    String accountNumber,
  ) async {
    String type = "nuban";
    String currency = "NGN";
    String uriString = "transferrecipient";
    String recipientCode;

    try {
      http.Client client = http.Client();
      var params = jsonEncode({
        "account_number": accountNumber,
        "name": accountName,
        "bank_code": bankCode,
        "type": type,
        "currency": currency,
      });

      http.Response response = await client.post(
        Uri.parse("$baseUrlPaystack/$uriString"),
        headers: {
          "Authorization": "Bearer $paystackSecretKey",
          "Content-Type": "application/json",
        },
        body: params,
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        recipientCode = body["data"]["recipient_code"];
        client.close();
        return recipientCode;
      } else {
        throw Exception("An error occurred when initiating recipient");
      }
    } catch (e) {
      print(e);
      throw Exception("An error occured, function failed to run");
    }
  }

  //helper function to initiate a transaction
  Future<String> initiatePaystackTransaction(
      num amount, String recipientCode, String reason) async {
    String narration = getNarration(reason);
    String reference = getReference();
    String source = "balance";
    String uriString = "transfer";
    String currency = "NGN";

    try {
      var params = {
        "amount": amount,
        "recipient": recipientCode,
        "source": source,
        "reason": narration,
        "reference": reference,
        "currency": currency,
      };
      http.Response response = await http.post(
        Uri.parse("$baseUrlPaystack/$uriString"),
        headers: {
          "Authorization": "Bearer $paystackSecretKey",
          "Content-Type": "application/json"
        },
        body: params,
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String status = body["data"]["status"];
        return status;
      } else {
        throw Exception(
            "An error occured trying to initiate transaction with status code ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("An error in trying to initiate transaction");
    }
  }

  //approve paystack payments
  Future<String> completePaystackPayment(
    String bankCode,
    String accountName,
    String accountNumber,
    num amount,
    String reason,
  ) async {
    String recipientCode = "";
    String status = "";
    String response = "";

    try {
      //first initiate transfer recipient
      recipientCode = await initiatePaystackTransferRecipient(
          bankCode, accountName, accountNumber);

      //then initiate transfer
      if (recipientCode != "") {
        status =
            await initiatePaystackTransaction(amount, recipientCode, reason);

        switch (status.toLowerCase()) {
          case "success":
            response = "success";
            break;
          case "pending":
            response = "pending";
            break;
          case "failed":
            response = "failed";
          default:
            response = "error";
        }
        return response;
      } else {
        throw Exception("recipient code not received");
      }
    } catch (e) {
      print(e);
      throw Exception("Completeing the paystack payment failed");
    }
  }

  //approve monnify payments
  Future<String> completeMonnifyPayment(
    num amount,
    String accountNumber,
    String accountName,
    String bankCode,
    String reason,
  ) async {
    String currency = "NGN";
    String narration = getNarration(reason);
    String reference = getReference();
    String uriString = "api/v2/disbursements/single";
    String returnValue = "";

    try {
      var params = {
        "amount": amount,
        "narration": narration,
        "reference": reference,
        "currency": currency,
        "destinationBankCode": bankCode,
        "destinationAccountNumber": accountNumber,
        "sourceAccountNumber": walletAccountNumber,
      };
      http.Response response = await http.post(
        Uri.parse("$baseUrlMonnify/$uriString"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: params,
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        String status = body["responseBody"]["status"];
        switch (status.toLowerCase()) {
          case "success":
            returnValue = "success";
            break;
          case "pending":
            returnValue = "pending";
            break;
          case "failed":
            returnValue = "failed";
          default:
            returnValue = "error";
        }
        return returnValue;
      } else if (response.statusCode == 401) {
        var body = jsonDecode(response.body);
        if (body["error"] == "invalid_token") {
          await generateMonnifyToken();
          await completeMonnifyPayment(
            amount,
            accountNumber,
            accountName,
            reason,
            bankCode,
          );
        } else {
          throw Exception("Authentication failed");
        }
      } else {
        throw Exception(
            "An error occured with error code ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to complete monnify payment $e");
    }
    throw Exception("Unexpected error occurred");
  }

  //get paystack balance
  Future<PaystackBalanceModel> getPaystackAccountBalance() async {
    try {
      String uriString = "/balance";
      http.Response response =
          await http.get(Uri.parse("$baseUrlPaystack/$uriString"), headers: {
        "Authorization": "Bearer $paystackSecretKey",
      });
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        PaystackBalanceModel balance =
            PaystackBalanceModel.fromJson(body["data"][0]);
        return balance;
      } else {
        throw Exception(
            "An error occurred with status code:${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  //get monnify balance
  Future<MonnifyBalanceModel> getMonnifyAccountBalance() async {
    try {
      String uriString = "api/v2/disbursements/wallet-balance?accountNumber=";
      http.Response response = await http.get(
          Uri.parse("$baseUrlMonnify/$uriString$walletAccountNumber"),
          headers: {
            "Authorization": "Bearer $accessToken",
          });
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        MonnifyBalanceModel balance =
            MonnifyBalanceModel.fromJson(body["responseBody"]);
        return balance;
      } else if (response.statusCode == 401) {
        var body = jsonDecode(response.body);
        if (body["error"] == "invalid_token") {
          await generateMonnifyToken();
          await getMonnifyAccountBalance();
        } else {
          throw Exception("Authentication failed");
        }
      } else {
        throw Exception("failed to get account balance");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    throw Exception("Unexpected error occurred");
  }

  //helper function to convert list of response object to list of transaction model
  List<TransactionsModel> convertToTransactionMonnify(List response) {
    List<TransactionsModel> transactions = [];
    for (var element in response) {
      TransactionsModel transaction = TransactionsModel(
        source: "monnify",
        accountName: element["destinationAccountName"],
        accountNumber: element["destinationAccountNumber"],
        bankName: element["destinationBankName"],
        createdAt: element["createdOn"],
        amount: element["amount"],
        status: element["status"],
      );
      transactions.add(transaction);
    }
    return transactions;
  }

  //fetch monnify transactions
  Future<List<TransactionsModel>> fetchMonnifyTransactions(
      num pageSize, num pageNo) async {
    try {
      String uriString =
          "api/v2/disbursements/single/transactions?pageSize=$pageSize&pageNo=$pageNo";
      http.Response response =
          await http.get(Uri.parse("$baseUrlMonnify/$uriString"), headers: {
        "Authorization": "Bearer $accessToken",
      });
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List transactionsFromBody = body["responseBody"]["content"];
        List<TransactionsModel> transactions =
            convertToTransactionMonnify(transactionsFromBody);
        return transactions;
      } else if (response.statusCode == 401) {
        var body = jsonDecode(response.body);
        if (body["error"] == "invalid_token") {
          await generateMonnifyToken();
          await getMonnifyAccountBalance();
        } else {
          throw Exception("Authentication failed");
        }
      } else {
        throw Exception("failed to get account balance");
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    throw Exception("Unexpected error occurred");
  }

  //fetch paystack transactions

  //helper function to generate transaction references
  String getReference() {
    return 'Reference_${DateTime.now().millisecondsSinceEpoch}';
  }

  //helper function to generate transaction narrations
  String getNarration(String reason) {
    String returnValue = "";
    if (reason.toLowerCase() == "cancellation") {
      returnValue = 'Order Cancellation';
    } else if (reason.toLowerCase() == "refund") {
      returnValue = 'Order Refund';
    } else if (reason.toLowerCase() == "withdrawal") {
      returnValue = "Withdrawal";
    }
    return returnValue;
  }
}
