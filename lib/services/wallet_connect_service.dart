import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WalletConnectService {
  late WalletConnect connector;
  late Web3Client client;

  WalletConnectService({required String rpcUrl}) {
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org', // WalletConnect bridge URL
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    // Initialize the web3 client with the provided RPC URL
    client = Web3Client('https://mainnet.infura.io/v3/da93b94afc4a40cdb6e8b05dc4a1433f', http.Client());

    // Subscribe to events
    _initializeListeners();
  }

  void _initializeListeners() {
    // Listen for connection
    connector.on('connect', (session) {
      print('Connected: $session');
    });

    // Listen for session updates
    connector.on('session_update', (payload) {
      print('Session updated: $payload');
    });

    // Listen for disconnection
    connector.on('disconnect', (session) {
      print('Disconnected: $session');
    });
  }

  Future<void> connect() async {
    // Check if already connected
    if (!connector.connected) {
      try {
        final session = await connector.createSession(
          chainId: 1, // Mainnet chain ID for Ethereum
          onDisplayUri: (uri) {
            print('QR Code URI: $uri'); // Display the QR code or link
          },
        );
        print('Session accounts: ${session.accounts}');
      } catch (e) {
        print('Error connecting: $e');
      }
    } else {
      print('Already connected: ${connector.session.accounts}');
    }
  }

  Future<void> approveSession(List<String> accounts) async {
    try {
      await connector.approveSession(chainId: 1, accounts: accounts);
      print('Session approved for accounts: $accounts');
    } catch (e) {
      print('Error approving session: $e');
    }
  }

  Future<void> rejectSession(String message) async {
    try {
      await connector.rejectSession(message: message);
      print('Session rejected: $message');
    } catch (e) {
      print('Error rejecting session: $e');
    }
  }

  Future<void> updateSession(List<String> accounts) async {
    try {
      await connector.updateSession(SessionStatus(chainId: 1, accounts: accounts));
      print('Session updated for accounts: $accounts');
    } catch (e) {
      print('Error updating session: $e');
    }
  }

  Future<void> sendTransaction(String toAddress, BigInt amount) async {
    // Retrieve the first account from the session
    final account = connector.session.accounts[0];

    // Create a transaction to send
    final tx = Transaction(
      to: EthereumAddress.fromHex(toAddress),
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
    );

    try {
      // Send the transaction
      final result = await client.sendTransaction(account as Credentials, tx);
      print('Transaction sent: $result');

      // Optionally check the transaction status
      final receipt = await client.getTransactionReceipt(result);
      if (receipt != null) {
        print('Transaction confirmed: $receipt');
      } else {
        print('Transaction not yet confirmed');
      }
    } catch (e) {
      print('Error sending transaction: $e');
    }
  }

  Future<void> payDownpayment(String recipientAddress, double amount) async {
    // Convert the amount to Wei (1 ETH = 10^18 Wei)
    BigInt amountInWei = BigInt.from((amount * 1e18).toInt()); // Convert to int first

    // Use the sendTransaction method to process the payment
    await sendTransaction(recipientAddress, amountInWei);
  }

  Future<void> killSession() async {
    try {
      await connector.killSession();
      print('Session killed');
    } catch (e) {
      print('Error killing session: $e');
    }
  }
}
