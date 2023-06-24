
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:wordsearch_puzzle/models/word_data_model.dart';
import 'package:wordsearch_puzzle/screens/word_search_home.dart';

///--------------------------------------------
///CategorySelectionPage
/// -------------------------------------------
class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({Key? key}) : super(key: key);

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

///--------------------------------------------
///_CategorySelectionPageState
/// -------------------------------------------
class _CategorySelectionPageState extends State<CategorySelectionPage> {
  late List<String> categories;
  String selectedWordSearchCategory = "";

  @override
  void initState() {
    super.initState();

    categories = getWordCategories();
    selectedWordSearchCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : const Text("Word Search - Category"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment. start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget> [

            const SizedBox(height: 60),

            const Text(
              'Select Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            //Build and display Word Search Categories
            buildDisplayWordSearchCategoriesMenu(),

            const SizedBox(height: 20),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>
                          WordSearchHome(category: selectedWordSearchCategory,)));
                },

                child: const Text(
                  "Start Word Search",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 4),

          ],
        ),
      ),

    );
  }

  ///
  /// Build and Display the Word Search Categories menus
  ///
  Column buildDisplayWordSearchCategoriesMenu() {
    return Column(
      children: <Widget> [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),

          margin: const EdgeInsets.all(0),

          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: selectedWordSearchCategory,
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
              ),

              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              isExpanded: true,
              // elevation: 16,

              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),

              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  selectedWordSearchCategory = value!;
                });
              },

              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

            ),
          ),
        ),
      ],
    );
  }

}
