class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String semester;
  final String profileImage;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.semester,
    required this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'semester': semester,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      department: map['department'] ?? '',
      semester: map['semester'] ?? '',
      profileImage: map['profileImage'] ?? '',
    );
  }
}