import "package:flutter/material.dart";
import "package:weather/provider.dart";
import "package:provider/provider.dart";
import "package:go_router/go_router.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go("/")),
      ),
      body: const Center(
        child: Text("Search"),
      ),
    );
  }
}
