import 'package:flutter/material.dart';
import 'package:meu_app/widgets/trash.button.widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.history, required this.onClear});
  final List<String> history;
  final VoidCallback onClear;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
      body: widget.history.isEmpty
          ? Center(
              child: Text(
                "Nenhum cálculo realizado",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: 250,
                    child: Card(
                      color: index.isEven ? Colors.grey[50] : Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          widget.history[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: widget.history.isNotEmpty
          ? Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TrashButton(
                  onPressed: () {
                    widget.onClear();
                    setState(() {});
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
