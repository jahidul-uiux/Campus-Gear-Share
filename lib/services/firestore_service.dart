import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get items =>
      _firestore.collection('items');

  Future<void> addItem(ItemModel item) async {
    await items.doc(item.id).set(item.toMap());
  }

  Stream<List<ItemModel>> getItems() {
    return items.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<ItemModel>> getUserItems(String sellerId) {
    return items
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> updateItem(ItemModel item) async {
    await items.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String itemId) async {
    await items.doc(itemId).delete();
  }
}