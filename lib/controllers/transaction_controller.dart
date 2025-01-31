import 'package:get/get.dart';
import 'package:hair_main_street_admin/models/transactions_model.dart';

class TransactionController extends GetxController {
  RxList<TransactionsModel> transactions = <TransactionsModel>[].obs;

  fetchTransactions() {}
}
