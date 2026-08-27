import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItemScreen extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> item;

  const EditItemScreen({
    super.key,
    required this.documentId,
    required this.item,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  late String category;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.item["title"]);

    descriptionController =
        TextEditingController(text: widget.item["description"]);

    priceController =
        TextEditingController(text: widget.item["price"].toString());

    category = widget.item["category"];
  }

  Future<void> updateItem() async {
    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance
        .collection("items")
        .doc(widget.documentId)
        .update({
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "price": double.parse(priceController.text),
      "category": category,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item Updated Successfully"),
      ),
    );

    Navigator.pop(context);

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Books",
                  child: Text("Books"),
                ),
                DropdownMenuItem(
                  value: "Electronics",
                  child: Text("Electronics"),
                ),
                DropdownMenuItem(
                  value: "Sports",
                  child: Text("Sports"),
                ),
                DropdownMenuItem(
                  value: "Others",
                  child: Text("Others"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : updateItem,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Update Item"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}