import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String sellerName = "";
  String sellerCollegeId = "";
  String sellerWhatsapp = "";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSellerProfile();
  }

  Future<void> loadSellerProfile() async {
    try {
      final sellerId = widget.item["sellerId"];

      if (sellerId != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(sellerId)
            .get();

        if (doc.exists) {
          final data = doc.data()!;

          sellerName = data["name"] ?? "Not Available";
          sellerCollegeId = data["collegeId"] ?? "Not Available";
          sellerWhatsapp = data["whatsapp"] ?? "";
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> emailSeller() async {
    final Uri uri = Uri(
      scheme: "mailto",
      path: widget.item["sellerEmail"],
      queryParameters: {
        "subject": "Enquiry about your product",
        "body":
            "Hello,\n\nI want to enquire about your product that you posted on CampusX.\n\nIs it still available?\n\nThank you."
      },
    );

    await launchUrl(uri);
  }

  Future<void> whatsappSeller() async {
    if (sellerWhatsapp.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Seller has not added a WhatsApp number.",
          ),
        ),
      );
      return;
    }

    final message = Uri.encodeComponent(
      "Hello,\n\nI want to enquire about your product that you posted on CampusX.\n\nIs it still available?",
    );

    final number = sellerWhatsapp.replaceAll("+", "");

    final Uri uri = Uri.parse(
      "https://wa.me/$number?text=$message",
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item["title"]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 100,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.item["title"],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "₹${widget.item["price"]}",
              style: const TextStyle(
                fontSize: 28,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.item["description"],
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Chip(
              label: Text(widget.item["category"]),
            ),

            const Divider(height: 40),

            const Text(
              "Seller Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Seller Name"),
                    subtitle: Text(sellerName),
                  ),

                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: const Text("College ID"),
                    subtitle: Text(sellerCollegeId),
                  ),

                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text("Email"),
                    subtitle: Text(
                      widget.item["sellerEmail"] ?? "Not Available",
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("WhatsApp"),
                    subtitle: Text(
                      sellerWhatsapp.isEmpty
                          ? "Not Provided"
                          : sellerWhatsapp,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: emailSeller,
                icon: const Icon(Icons.email),
                label: const Text(
                  "Email Seller",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: whatsappSeller,
                icon: const Icon(Icons.chat),
                label: const Text(
                  "WhatsApp Seller",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}