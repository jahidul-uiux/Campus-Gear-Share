import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_item_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        userData = doc.data();
      });
    }
  }

  Future<void> deleteItem(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text(
            "Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          )
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection("items")
        .doc(id)
        .delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Item Deleted"),
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("items")
            .where("sellerId", isEqualTo: user!.uid)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),

            children: [

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      CircleAvatar(
                        radius: 45,
                        backgroundColor:
                            Colors.green.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        userData!["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        userData!["collegeId"] ?? "",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const Divider(height: 30),

                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text("Email"),
                        subtitle: Text(
                          userData!["email"] ?? "",
                        ),
                      ),

                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text("WhatsApp"),
                        subtitle: Text(
                          (userData!["whatsapp"] ?? "").isEmpty
                              ? "Not Added"
                              : userData!["whatsapp"],
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit Profile"),

                          onPressed: () async {

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const EditProfileScreen(),
                              ),
                            );

                            loadProfile();

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "My Listings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              if (docs.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "You haven't posted any items yet.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...docs.map((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Chip(
                            label: Text(
                              data["category"] ?? "",
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            data["description"] ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "₹${data["price"]}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  icon:
                                      const Icon(Icons.edit),
                                  label:
                                      const Text("Edit"),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditItemScreen(
                                          documentId:
                                              doc.id,
                                          item: data,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: FilledButton.icon(
                                  style:
                                      FilledButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  label:
                                      const Text("Delete"),
                                  onPressed: () {
                                    deleteItem(doc.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  onPressed: logout,
                ),
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}