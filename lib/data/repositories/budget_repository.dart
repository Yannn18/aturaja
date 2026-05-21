import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aturaja/data/models/budget_item_model.dart';

/// Repository class for managing budget items in Cloud Firestore.
///
/// This class provides an abstraction layer for all Firestore operations related to budgets.
/// It handles data persistence, retrieval, and updates using the 'budgets' collection.
/// All methods are asynchronous to account for network I/O operations.
///
/// **Firestore Collection Structure:**
/// - Collection: 'budgets'
/// - Documents: Identified by budget.id
/// - Fields: id, title, usedBudget, totalBudget, category
class BudgetRepository {
  /// Reference to the Firestore instance.
  ///
  /// Firestore is Firebase's cloud database solution. [FirebaseFirestore.instance]
  /// gives us a singleton instance to interact with the database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Name of the collection storing all budget documents in Firestore.
  ///
  /// Collections in Firestore are like tables in a relational database.
  /// This repository exclusively works with the 'budgets' collection.
  static const String _collectionName = 'budgets';

  /// Fetch all budget documents from the Firestore 'budgets' collection.
  ///
  /// **How it works:**
  /// 1. `.collection(_collectionName)` - Points to the 'budgets' collection
  /// 2. `.get()` - Fetches ALL documents from the collection in one async call.
  ///    This returns a [QuerySnapshot] containing a list of documents.
  /// 3. `.docs` - Extracts the list of [DocumentSnapshot] objects.
  /// 4. `.map()` - Transforms each DocumentSnapshot into a BudgetItemModel:
  ///    - `doc.data()` extracts the document's data as a Map<String, dynamic>
  ///    - `BudgetItemModel.fromJson()` reconstructs the model from the map
  /// 5. `.toList()` - Converts the lazy mapped iterable into a concrete List.
  ///
  /// **Error Handling:**
  /// - Network failures or permission errors throw a FirebaseException
  /// - The try-catch block catches these and rethrows with context
  ///
  /// **Returns:**
  /// A List containing all BudgetItemModel instances from Firestore.
  /// Returns an empty list if no documents exist.
  ///
  /// **Throws:**
  /// [FirebaseException] if there's a network error, authentication issue,
  /// or insufficient permissions to read the collection.
  Future<List<BudgetItemModel>> getBudgets() async {
    try {
      // Fetch all documents from the 'budgets' collection
      // .get() returns a QuerySnapshot which is a snapshot of the collection at this moment
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(_collectionName)
          .get();

      // Transform each DocumentSnapshot into a BudgetItemModel
      // Each document's data is passed to the fromJson factory constructor
      final List<BudgetItemModel> budgets = querySnapshot.docs.map((
        DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
        // doc.data() returns the actual data stored in the document
        // We use the non-null assertion (!) because get() ensures data exists
        return BudgetItemModel.fromJson(doc.data()!);
      }).toList();

      return budgets;
    } on FirebaseException catch (e) {
      // Catch Firebase-specific errors (network, auth, permissions)
      throw Exception('Failed to fetch budgets from Firestore: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception(
        'An unexpected error occurred while fetching budgets: $e',
      );
    }
  }

  /// Insert a new budget document into the Firestore 'budgets' collection.
  ///
  /// **How it works:**
  /// 1. `.collection(_collectionName)` - Points to the 'budgets' collection
  /// 2. `.doc(budget.id)` - Creates or references a document with the given ID.
  ///    This ensures consistency: the same budget ID always maps to the same document.
  /// 3. `.set(budget.toJson())` - Writes/overwrites the document data.
  ///    `budget.toJson()` converts the model into a Map<String, dynamic> suitable for Firestore.
  /// 4. The operation is atomic: either the entire document is written or nothing happens.
  ///
  /// **Why use .set() instead of .add()?**
  /// - `.set()` lets us specify the document ID (budget.id), ensuring consistency
  /// - `.add()` auto-generates IDs, which we don't want here
  ///
  /// **Error Handling:**
  /// - Permission errors, network issues, or validation errors throw FirebaseException
  /// - We catch and rethrow with a meaningful message
  ///
  /// **Parameters:**
  /// - [budget]: The BudgetItemModel to insert. Must have a valid non-empty id.
  ///
  /// **Throws:**
  /// [FirebaseException] if there's a network error, authentication issue,
  /// or insufficient permissions to write to the collection.
  Future<void> addBudget(BudgetItemModel budget) async {
    try {
      // Reference the document using the budget's ID as the document ID
      // This ensures that budget.id in memory matches the document ID in Firestore
      final DocumentReference<Map<String, dynamic>> docRef = _firestore
          .collection(_collectionName)
          .doc(budget.id);

      // Write the budget data to Firestore
      // budget.toJson() converts the model to a Map suitable for storage
      // SetOptions(merge: false) means: overwrite the entire document if it exists
      // (merge: true would merge fields instead, but we want a complete replace)
      await docRef.set(budget.toJson());
    } on FirebaseException catch (e) {
      // Catch Firebase-specific errors
      throw Exception('Failed to add budget to Firestore: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception('An unexpected error occurred while adding budget: $e');
    }
  }

  /// Update an existing budget document in the Firestore 'budgets' collection.
  ///
  /// **How it works:**
  /// 1. `.collection(_collectionName)` - Points to the 'budgets' collection
  /// 2. `.doc(budget.id)` - References the document with the given ID
  /// 3. `.update(budget.toJson())` - Merges the provided data with the existing document.
  ///    Only the fields in the map are updated; other fields remain unchanged.
  ///    This is safer than .set() when you don't want to overwrite the entire document.
  /// 4. If the document doesn't exist, a FirebaseException is thrown.
  ///
  /// **Difference between .set() and .update():**
  /// - `.set()` overwrites the entire document (dangerous if fields are missing)
  /// - `.update()` only updates specified fields, preserving other data
  /// - `.update()` fails if the document doesn't exist (safer for updates)
  ///
  /// **Error Handling:**
  /// - Document not found, permission errors, or network issues throw FirebaseException
  /// - We catch and rethrow with context
  ///
  /// **Parameters:**
  /// - [budget]: The BudgetItemModel with updated values. Must exist in Firestore.
  ///
  /// **Throws:**
  /// [FirebaseException] if the document doesn't exist, there's a network error,
  /// authentication issue, or insufficient permissions to update.
  Future<void> updateBudget(BudgetItemModel budget) async {
    try {
      // Reference the document using the budget's ID
      final DocumentReference<Map<String, dynamic>> docRef = _firestore
          .collection(_collectionName)
          .doc(budget.id);

      // Update the document with new data
      // .update() merges the data: only specified fields are changed
      // Fields not in the map remain unchanged in Firestore
      await docRef.update(budget.toJson());
    } on FirebaseException catch (e) {
      // Catch Firebase-specific errors, including "document not found"
      throw Exception('Failed to update budget in Firestore: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception('An unexpected error occurred while updating budget: $e');
    }
  }
}
