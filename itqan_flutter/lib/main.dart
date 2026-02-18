import 'package:flutter/material.dart';
import 'package:itqan_flutter/screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pidgnqlfhozyosgtmsmg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpZGducWxmaG96eW9zZ3Rtc21nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExNzU2NTMsImV4cCI6MjA4Njc1MTY1M30.LGw9nvg6WauO_q2Iipym_BdyeTqol_n1CN2n89EAHCc',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Itqan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2ECC71)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
