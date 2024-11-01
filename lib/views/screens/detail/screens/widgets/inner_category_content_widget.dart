import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/controllers/subcategory_controller.dart';
import 'package:mac_store_app/models/category.dart';
import 'package:mac_store_app/models/product.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:mac_store_app/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:mac_store_app/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:mac_store_app/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;

  const InnerCategoryContentWidget({super.key, required this.category});
  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subCategories;
  late Future<List<Product>> futureProducts;
  final SubcategoryController _subcategoryController = SubcategoryController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subCategories = _subcategoryController
        .getSubCategoriesByCategoryName(widget.category.name);
    futureProducts =
        ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
        child: const InnerHeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text(
                'Shop By Category',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
                future: _subCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Categories'),
                    );
                  } else {
                    final subcategories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                          children: List.generate(
                              (subcategories.length / 7).ceil(), (setIndex) {
                        //for each row, calculate the startting and ending indices
                        final start = setIndex * 7;
                        final end = (setIndex + 1) * 7;

                        //Create a padding widget to add spacing arround the row
                        return Padding(
                          padding: const EdgeInsets.all(8.9),
                          child: Row(
                            //create a row of the subcategory tie
                            children: subcategories
                                .sublist(
                                    start,
                                    end > subcategories.length
                                        ? subcategories.length
                                        : end)
                                .map((subcategory) => SubcategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName,
                                    ))
                                .toList(),
                          ),
                        );
                      })),
                    );
                  }
                }),
            const ReusableTextWidget(
                title: 'Popular Product', subtitle: 'View all'),
            FutureBuilder(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No product under this category'),
                    );
                  } else {
                    final products = snapshot.data;
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItemWidget(
                              product: product,
                            );
                          }),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
