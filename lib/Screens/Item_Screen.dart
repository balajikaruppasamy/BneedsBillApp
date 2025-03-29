import 'package:bneedsbillappnew/Controller/Item_Controller.dart';
import 'package:bneedsbillappnew/Utility/Logger.dart';
import 'package:bneedsbillappnew/Widgets/Common_BottomNavigatoin.dart';
import 'package:bneedsbillappnew/Widgets/Common_Dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  bool _isLoading = true;
  String selectedItem = '';
  final controller = Get.put(ItemController());

  void showbottomsheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final TextEditingController searchController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      final filteredItems =
                          controller.dropdownItems.where((item) {
                        return item.toLowerCase().contains(
                              searchController.text.toLowerCase(),
                            );
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return Center(child: Text("No categories available"));
                      }

                      return ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final category = filteredItems[index];
                          return ListTile(
                            title: Text(
                              category,
                              style: TextStyle(fontSize: 15),
                            ),
                            onTap: () {
                              controller.selectedCategory.value = category;
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommonBottomnavigation())),
            icon: Icon(Icons.keyboard_arrow_left)),
        title: Text('Add Items'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: controller.Itemcontrollerkey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.Itemname_eng,
                  decoration: InputDecoration(
                    labelText: 'Item Name(English)',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.Itemname_tam,
                  decoration: InputDecoration(
                    labelText: 'Item Name(Tamil)',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.mrp,
                        decoration: InputDecoration(
                          labelText: 'Mrp',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.Pur_rate,
                        decoration: InputDecoration(
                          labelText: 'purchase rate',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller.Sell_rate,
                        decoration: InputDecoration(
                          labelText: 'selling rate',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller.gst,
                        decoration: InputDecoration(
                          labelText: 'Gst',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: controller.selectedCategory.value.isEmpty
                          ? "Select a category"
                          : controller.selectedCategory.value,
                    ),
                    decoration: InputDecoration(
                      hintText: "Select a category",
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () {
                      showbottomsheet();
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.AddItementry();
                        },
                        child: Text('Add Items'))),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.Itemmamster.length,
                      itemBuilder: (context, index) {
                        final itemmaster = controller.Itemmamster[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        itemmaster['ITEMNAME_ENG'] ?? 'No Name',
                                        softWrap: true,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        itemmaster['CATEGORY'] ?? '',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildPriceColumn(
                                  "PUR RATE",
                                  itemmaster['PUR_RATE'] ?? '₹ 0.00',
                                ),
                                _buildPriceColumn(
                                  "GST",
                                  itemmaster['GST'] ?? '₹ 0.00',
                                ),
                                _buildPriceColumn(
                                  "SELL RATE",
                                  itemmaster['SELL_RATE'] ?? '₹ 0.00',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceColumn(String title, String value, {bool isStock = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isStock ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
