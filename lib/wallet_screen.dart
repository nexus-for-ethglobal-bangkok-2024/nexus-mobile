import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold());
  }
}

/*

ElevatedButtonTheme(
                  data: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 195, 47, 233),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  child: Visibility(
                    visible: logoutVisible,
                    child: Column(
                      children: [
                        Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _logout(),
                              child: const Column(
                                children: [
                                  Text('Logout'),
                                ],
                              )),
                        ),
                        const Text(
                          'Blockchain calls',
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          onPressed: _getUserInfo,
                          child: const Text('Get UserInfo'),
                        ),
                        ElevatedButton(
                          onPressed: _getAddress,
                          child: const Text('Get Address'),
                        ),
                        ElevatedButton(
                          onPressed: _getBalance,
                          child: const Text('Get Balance'),
                        ),
                        ElevatedButton(
                          onPressed: _sendTransaction,
                          child: const Text('Send Transaction'),
                        ),
                      ],
                    ),
                  ),
                ),

*/
