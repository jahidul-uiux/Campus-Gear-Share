import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  String category = "Books";

  bool isLoading = false;

  Future<void> addItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection("items").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "price": double.parse(priceController.text),
        "category": category,
        "sellerEmail": user?.email,
        "sellerId": user?.uid,
        "createdAt": Timestamp.now(),
      });

      titleController.clear();
      descriptionController.clear();
      priceController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item Added Successfully"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Sell an Item",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter item name" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter description" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter price" : null,
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Books", child: Text("Books")),
                  DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
                  DropdownMenuItem(value: "Sports", child: Text("Sports")),
                  DropdownMenuItem(value: "Others", child: Text("Others")),
                ],
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addItem,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Post Item"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}