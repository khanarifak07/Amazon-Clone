import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController quantityCtrl = TextEditingController();

  String category = "Mobiles";
  List<String> productCategories = [
    "Mobiles",
    "Appliances",
    "Essentials",
    "Books",
    "Fashions"
  ];

  bool isLoading = false;
  List<File>? images;

  Future<void> pickImages() async {
    var pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        images = pickedImages.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> addProduct({
    required ProductModel productModel,
    required List<File> productImages,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      //get the saved access Token
      var prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      // Create a list of MultipartFile from the images
      List<MultipartFile> imageFiles = [];
      for (File image in productImages) {
        imageFiles.add(
          await MultipartFile.fromFile(
            image.path,
            filename:
                'product_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }
      //send the formdata as you are passing images also
      FormData formData = FormData.fromMap({
        'name': productModel.name,
        'description': productModel.description,
        'price': productModel.price,
        'quantity': productModel.quantity,
        'category': productModel.category,
        'images': imageFiles,
      });

      //make dio post request
      Response response = await dio.post(addProductApi,
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      //handle the response
      if (response.statusCode == 200) {
        log("Product added successfully ${response.data}");
      } else {
        log("Product added Failed ${response.statusCode}");
      }
    } catch (e) {
      print("Errow while adding product $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 50),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: const Text(
              "Add Product",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickImages();
                },
                child: images != null
                    ? CarouselSlider.builder(
                        itemCount: images!.length,
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Image.file(
                                images![index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                        ))
                    : DottedBorder(
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [15, 5],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        child: Container(
                          height: 200,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, size: 50),
                              SizedBox(height: 10),
                              Text("Select Product Image")
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 30),
              CustomTextField(labelText: "Product Name", controller: nameCtrl),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Product Description",
                controller: descriptionCtrl,
                maxLines: 6,
              ),
              const SizedBox(height: 10),
              CustomTextField(labelText: "Price", controller: priceCtrl),
              const SizedBox(height: 10),
              CustomTextField(labelText: "Quantity", controller: quantityCtrl),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.maxFinite,
                  child: DropdownButton(
                    value: category,
                    items: productCategories.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        category = val!;
                      });
                    },
                  )),
              const Spacer(),
              /* CustomButtom(
                  ontap: () async {
                    await addProduct(
                      productModel: ProductModel(
                        images: images!
                            .map((File file) => file.path)
                            .toList(), // Use null-aware operator to handle null case
                        name: nameCtrl.text,
                        description: descriptionCtrl.text,
                        price: double.parse(priceCtrl.text),
                        quantity: double.parse(quantityCtrl.text),
                        category: category,
                      ),
                      productImages: images ??
                          [], // Use null-aware operator to handle null case
                    );
                  },
                  child: const Text("Sell")), */
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        await addProduct(
                          productModel: ProductModel(
                            images: images!
                                .map((File file) => file.path)
                                .toList(), // Use null-aware operator to handle null case
                            name: nameCtrl.text,
                            description: descriptionCtrl.text,
                            price: int.parse(priceCtrl.text),
                            quantity: int.parse(quantityCtrl.text),
                            category: category,
                          ),
                          productImages: images ??
                              [], // Use null-aware operator to handle null case
                        );
                      },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                  double.maxFinite,
                  50,
                )),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Sell"),
              )
            ],
          ),
        ));
  }
}
