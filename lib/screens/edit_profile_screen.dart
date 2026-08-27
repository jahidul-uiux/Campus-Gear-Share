import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController collegeIdController =
      TextEditingController();
  final TextEditingController whatsappController =
      TextEditingController();

  bool isLoading = true;
  bool isSaving = false;

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
      final data = doc.data()!;

      nameController.text = data["name"] ?? "";
      collegeIdController.text = data["collegeId"] ?? "";
      whatsappController.text = data["whatsapp"] ?? "";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveProfile() async {
    if (user == null) return;

    setState(() {
      isSaving = true;
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set({
      "uid": user!.uid,
      "email": user!.email,
      "name": nameController.text.trim(),
      "collegeId": collegeIdController.text.trim(),
      "whatsapp": whatsappController.text.trim(),
    }, SetOptions(merge: true));

    setState(() {
      isSaving = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    collegeIdController.dispose();
    whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: collegeIdController,
              decoration: const InputDecoration(
                labelText: "College ID",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: whatsappController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "WhatsApp Number",
                hintText: "+91XXXXXXXXXX",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              enabled: false,
              controller: TextEditingController(
                text: user?.email ?? "",
              ),
              decoration: const InputDecoration(
                labelText: "Registered Email",
                helperText: "Email cannot be changed",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveProfile,
                icon: isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isSaving ? "Saving..." : "Save Profile",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}