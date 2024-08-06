import 'package:upi_india/upi_india.dart';

import 'app_constant.dart';

class UpiPaymentService {
  // button clicked
  bool hundred = false,
      fivehundred = false,
      thousand = false,
      twothousand = false;

  final UpiIndia _upiIndia = UpiIndia();

  // Fetches the list of all UPI apps installed on the device.
  Future<List<UpiApp>?> getAllUpiApps() async {
    try {
      return await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
    } catch (e) {
      print("Error fetching UPI apps: $e");
      return [];
    }
  }

  // Initiates a transaction using the selected UPI app.
  Future<int> initiateTransaction(UpiApp app, int amount) async {
    try {
      UpiResponse response = await _upiIndia.startTransaction(
        app: app,
        receiverUpiId: upiId,
        receiverName: 'G Vishnu Vishwas',
        transactionRefId: 'TestingUpiIndiaPlugin',
        transactionNote: 'Not actual. Just an example.',
        amount: amount.toDouble(),
      );

      // Handle the transaction response.
      if (response.status == UpiPaymentStatus.SUCCESS) {
        print("Transaction Successful");
        print("Transaction ID: ${response.transactionId}");
      } else if (response.status == UpiPaymentStatus.SUBMITTED) {
        print("Transaction Submitted");
      } else if (response.status == UpiPaymentStatus.FAILURE) {
        print("Transaction Failed");
      }
    } catch (e) {
      // Handle exceptions based on the type of error.
      if (e is UpiIndiaAppNotInstalledException) {
        print("Requested app not installed on device");
      } else if (e is UpiIndiaUserCancelledException) {
        print("You cancelled the transaction");
      } else if (e is UpiIndiaNullResponseException) {
        print("Requested app didn't return any response");
      } else if (e is UpiIndiaInvalidParametersException) {
        print("Requested app cannot handle the transaction");
      } else {
        print("An Unknown error has occurred");
      }
    }
    return amount;
  }
}
