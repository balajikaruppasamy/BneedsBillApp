import 'package:bneedsbillappnew/Controller/Catogory_Controller.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:bneedsbillappnew/Widgets/Common_Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreens extends StatefulWidget {
  const CategoryScreens({super.key});

  @override
  State<CategoryScreens> createState() => _CategoryScreensState();
}

class _CategoryScreensState extends State<CategoryScreens> {
  String? selectedDocId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CatogoryController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          leading: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonBottomnavigation(),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          title: const Text('ADD CATEGORY'),
        ),
        drawer: CommonDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Form(
                  key: controller.Catogorykey,
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.englishCatogory,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.production_quantity_limits),
                          labelText: 'Category Name (English)',
                        ),
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.tamilCatogory,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.production_quantity_limits),
                          labelText: 'Category Name (Tamil)',
                        ),
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.addOrUpdateCategory(
                                docId: selectedDocId);
                          },
                          child: Text(selectedDocId == null
                              ? 'Add Category'
                              : 'Update Category'),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(
                  height: 550,
                  child: Obx(() {
                    if (controller.categories.isEmpty) {
                      return const Center(
                        child: Text(
                          'No categories found.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.indigo.withOpacity(0.5),
                          child: ListTile(
                            title: Text(
                              category['CATEGORY'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              category['TAMIL_CATEGORY'] ?? 'No Description',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDocId = category[
                                          'docId']; // Get docId of the category to edit
                                      controller.englishCatogory.text =
                                          category['CATEGORY'] ?? '';
                                      controller.tamilCatogory.text =
                                          category['TAMIL_CATEGORY'] ?? '';
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text(
                                            'Are you sure you want to delete this category?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back(); // Close the dialog
                                            },
                                            child: Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              controller.deleteCategory(
                                                  category['docId']);
                                            },
                                            child: Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
