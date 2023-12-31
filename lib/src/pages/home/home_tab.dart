import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/common_widgets/app_name_widget.dart';
import 'package:greengrocer/src/pages/common_widgets/custom_shimmer.dart';
import 'package:greengrocer/src/pages/home/components/category_tile.dart';
import 'package:greengrocer/src/config/app_data.dart' as app_data;
import 'package:greengrocer/src/pages/home/components/item_tile.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'Frutas';
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  final UtilsServices utilsServices = UtilsServices();

  void itemSelectedCartAnimation(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runToCartAnimation) {
        runAddToCartAnimation = runToCartAnimation;
      },
      cartKey: globalKeyCartItems,
      height: 10,
      width: 10,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
          rotation: false,
          curve: Curves.ease,
          duration: Duration(
            milliseconds: 300,
          )),
      child: Scaffold(
        //appBar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const AppNameWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: GestureDetector(
                onTap: () {},
                child: Badge(
                  offset: const Offset(-5, -8),
                  backgroundColor: CustomColors.customContrastColor,
                  label: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  child: AddToCartIcon(
                    badgeOptions: const BadgeOptions(
                      active: false,
                    ),
                    key: globalKeyCartItems,
                    icon: Icon(
                      Icons.shopping_cart,
                      color: CustomColors.customSwatchColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        body: Column(
          children: [
            //campo pesquisa

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    hintText: 'Pesquise aqui...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: CustomColors.customContrastColor,
                      size: 21,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ))),
              ),
            ),

            //Categorias

            Container(
                height: 40,
                padding: const EdgeInsets.only(left: 24),
                child: !isLoading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            onPressed: () {
                              setState(() {
                                selectedCategory = app_data.categories[index];
                              });
                            },
                            category: app_data.categories[index],
                            isSelected:
                                app_data.categories[index] == selectedCategory,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: app_data.categories.length,
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          10,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 12),
                            alignment: Alignment.center,
                            child: CustomShimmer(
                              height: 20,
                              width: 80,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )),

            // Grid

            Expanded(
              child: !isLoading
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 9 / 11.5,
                      ),
                      itemCount: app_data.items.length,
                      itemBuilder: (context, index) {
                        return ItemTile(
                          item: app_data.items[index],
                          cartAnimationMethod: itemSelectedCartAnimation,
                        );
                      })
                  : GridView.count(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 11.5,
                      children: List.generate(
                        10,
                        (index) => CustomShimmer(
                          height: double.infinity,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
