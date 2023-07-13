import "package:flutter/material.dart";
import "package:weather/provider.dart";
import "package:provider/provider.dart";
import "package:go_router/go_router.dart";

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/"),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Weather"),
            SizedBox(
              height: 20,
            ),
            Text("Version 1.0.0"),
          ],
        ),
      ),
    );
  }
}
