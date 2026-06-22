import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum NetworkStatus { online, offline, checking }

class NetworkNotifier extends Notifier<NetworkStatus> {
  StreamSubscription? _connectivitySubscription;

  @override
  NetworkStatus build() {
    // Gunakan ref.onDispose untuk membersihkan stream
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    _init();
    return NetworkStatus.checking;
  }

  void _init() {
    // Dengarkan perubahan konektivitas
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      _checkInternetConnection(results);
    });
    
    // Lakukan cek awal saat provider dibuat
    Connectivity().checkConnectivity().then(_checkInternetConnection);
  }

  Future<void> _checkInternetConnection(List<ConnectivityResult> results) async {
    // Jika perangkat secara fisik tidak terhubung ke WiFi atau Seluler
    if (results.contains(ConnectivityResult.none)) {
      if (state != NetworkStatus.offline) {
        state = NetworkStatus.offline;
      }
      return;
    }

    // Walaupun terhubung WiFi, kita perlu cek apakah WiFi tersebut ada koneksi internetnya (ping)
    final hasInternet = await InternetConnection().hasInternetAccess;
    final newStatus = hasInternet ? NetworkStatus.online : NetworkStatus.offline;
    
    if (state != newStatus) {
      state = newStatus;
    }
  }
}

final networkProvider = NotifierProvider<NetworkNotifier, NetworkStatus>(() {
  return NetworkNotifier();
});
