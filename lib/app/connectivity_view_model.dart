import 'package:connectivity/connectivity.dart';

class ConnectivityViewModel {
  /// Uses [Connectivity] library to monitor the user of their current
  /// internet connection.

  static final Connectivity _connectivity = Connectivity();
  ConnectivityResult currentConnectivity;

  ConnectivityViewModel(this.currentConnectivity);
  ConnectivityViewModel.init() : currentConnectivity = null;

  bool get isNotConnected => currentConnectivity == ConnectivityResult.none;

  static Stream<ConnectivityViewModel> get stream => _connectivity
      .onConnectivityChanged
      .map((connectivityResult) => ConnectivityViewModel(connectivityResult));
}
