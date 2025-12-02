import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LazyRemoteApp());
}

class LazyRemoteApp extends StatelessWidget {
  const LazyRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        colorScheme: const ColorScheme.dark(primary: Colors.tealAccent)
      ),
      home: const RemotePage(),
    );
  }
}

class RemotePage extends StatefulWidget {
  const RemotePage({super.key});

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {

  final String serverUrl = 'http://10.0.2.2:3000';

  String status = "Ready";

  Future<void> sendCommand(String endpoint) async {
    setState(() => "Mengirim $endpoint");
    try {
      final response = await http.post(Uri.parse('$serverUrl/$endpoint'));
      if(response.statusCode == 200) {
        setState(() => status = "Success: $endpoint");
      } else {
        setState(() => status = "Failed: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => status = "Error: Koneksi/IP");
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => status = "Ready");
    });
  }
}