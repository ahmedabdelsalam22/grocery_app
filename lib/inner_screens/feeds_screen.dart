import 'package:beniseuf/consts/consts.dart';
import 'package:beniseuf/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/feed_item.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/FeedsScreen';
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}


class _FeedsScreenState extends State<FeedsScreen> {

  final TextEditingController? _searchController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  //search
  List<ProductModel> listProductSearch = [];

  @override
  void dispose()
  {
    _searchController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }


  /*@override
  void initState()
  {
   final productsProvider = Provider.of<ProductsProvider>(context,listen: false);
   productsProvider.fetchProducts();
    super.initState();
  }
*/


  @override
  Widget build(BuildContext context) {

    final Utils utils = Utils(context);

    final Size size = utils.getScreenSize;
    final Color color = utils.color;

    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: const BackWidget(),
        title: TextWidget(
          text: 'All Products',
          color: color,
          textSize: 22,
          isTitle: true,
        ),
      ),

      body:SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchController,
                  onChanged: (value){
                    setState((){
                      setState((){
                        listProductSearch = productsProvider.searchQuery(value);
                      });
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.greenAccent,width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.greenAccent,width: 1),
                    ),
                    hintText: "what's in your mind?",
                    prefixIcon: const Icon(Icons.search),
                    suffix: IconButton(
                      onPressed: (){
                        _searchController!.clear();
                        _searchTextFocusNode.unfocus();
                      },
                      icon: Icon(Icons.close ,
                        color: _searchTextFocusNode.hasFocus? Colors.red : color,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            _searchController!.text.isNotEmpty && listProductSearch.isEmpty?
            const EmptyProdWidget(text: 'No products found,please try another keyword')
                :
            GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height*0.59),
              children: List.generate(
                  _searchController!.text.isNotEmpty?
                  listProductSearch.length :
                  allProducts.length, (index){
                return ChangeNotifierProvider.value(
                    value: _searchController!.text.isNotEmpty?
                    listProductSearch[index] :
                    allProducts[index],
                    child: const FeedsWidget());
              }),
            ),
          ],
        ),
      ) ,
    );
  }
}
