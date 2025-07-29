import 'package:flutter/material.dart';
import 'package:gkmarts/Provider/Connectivity/connectivity_provider.dart';
import 'package:provider/provider.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOnline ? 0 : 30,
      width: double.infinity,
      color: Colors.red,
      alignment: Alignment.center,
      child: isOnline
          ? null
          : const Text(
              "No Internet Connection",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
    );
  }
}