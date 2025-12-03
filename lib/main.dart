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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remote App"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),

            Center(
              child: RemoteButton(
                icon: Icons.play_arrow_rounded,
                size: 100,
                color: Colors.tealAccent,
                onTap: () => sendCommand('play_pause'),
              ),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RemoteButton (
                  icon: Icons.volume_down_rounded,
                  size: 70,
                  color: Colors.orangeAccent,
                  onTap: () => sendCommand('vol_down'),
                ),
                RemoteButton(
                  icon: Icons.volume_up_rounded,
                  size: 70,
                  color: Colors.greenAccent,
                  onTap: () => sendCommand('vol_up')
                ),
                RemoteButton(
                  icon: Icons.volume_off_rounded,
                  size: 70,
                  color: Colors.redAccent,
                  onTap: () => sendCommand('mute')
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RemoteButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const RemoteButton({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Icon(icon, size: size * 0.5, color: color),
        ),
      ),
    );
  }
}