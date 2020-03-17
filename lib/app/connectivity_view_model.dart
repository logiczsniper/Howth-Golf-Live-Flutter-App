import 'package:connectivity/connectivity.dart';

class ConnectivityViewModel {
  static final Connectivity _connectivity = Connectivity();
  ConnectivityResult currentConnectivity;

  ConnectivityViewModel(this.currentConnectivity);
  ConnectivityViewModel.init() : currentConnectivity = null;

  bool get isNotConnected => currentConnectivity == ConnectivityResult.none;

  static Stream<ConnectivityViewModel> get stream => _connectivity
      .onConnectivityChanged
      .map((connectivityResult) => ConnectivityViewModel(connectivityResult));
}
