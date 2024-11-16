import 'package:flutter/material.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  bool isCrypto = true;
  bool isUSD = false;
  bool isStock = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Card(
            elevation: 100,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.black,
            color: const Color.fromARGB(255, 43, 43, 43),
            borderOnForeground: true,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Buy Stocks with Crypto",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Swap Crypto, Convert USD, purchase stocks",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCrypto = true;
                            isUSD = false;
                            isStock = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color:
                                  isCrypto ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Swap USD",
                            style: TextStyle(
                                color: isCrypto ? Colors.black : Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCrypto = false;
                            isUSD = true;
                            isStock = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isUSD ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Convert USD",
                            style: TextStyle(
                                color: isUSD ? Colors.black : Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCrypto = false;
                            isUSD = false;
                            isStock = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color:
                                  isStock ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Buy Stock",
                            style: TextStyle(
                                color: isStock ? Colors.black : Colors.white,
                                fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isCrypto ? crypto() : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget crypto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("From Chain", style: TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 15,
                ),
                DropdownMenu(width: 135, dropdownMenuEntries: [
                  DropdownMenuEntry(value: "Ethereum", label: "Ethereum"),
                  DropdownMenuEntry(
                      value: "Binance Smart Chain",
                      label: "Binance Smart Chain"),
                  DropdownMenuEntry(value: "Polygon", label: "Polygon"),
                  DropdownMenuEntry(value: "Solana", label: "Solana")
                ])
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "From Crypto",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                DropdownMenu(width: 130, dropdownMenuEntries: [
                  DropdownMenuEntry(value: "ETH", label: "ETH"),
                  DropdownMenuEntry(value: "BTC", label: "BTC"),
                  DropdownMenuEntry(value: "USDT", label: "USDT"),
                  DropdownMenuEntry(value: "BNB", label: "BNB")
                ])
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Amount",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "0.00"),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_downward,
                color: Colors.white,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "USDT Amount",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "0.00"),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Center(
            child: Text(
              "Swap to USDT",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Total Amount\$ 0.0",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
