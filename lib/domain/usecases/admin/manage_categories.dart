class ManageCategories {
  final List<Map<String, dynamic>> _categories = [];

  Future<List<Map<String, dynamic>>> getCategories() async {
    return _categories;
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    _categories.add(data);
  }

  Future<void> updateCategory(int index, Map<String, dynamic> data) async {
    if (index >= 0 && index < _categories.length) {
      _categories[index] = data;
    }
  }

  Future<void> deleteCategory(int index) async {
    if (index >= 0 && index < _categories.length) {
      _categories.removeAt(index);
    }
  }
}
