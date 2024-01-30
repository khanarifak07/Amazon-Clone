import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescCtrl = TextEditingController();
  TextEditingController proPriceCtrl = TextEditingController();
  TextEditingController proQtyCtrl = TextEditingController();

  String category = "Mobiles";
  List<String> productCategories = [
    "Mobiles",
    "Appliances",
    "Essentials",
    "Books",
    "Fashions"
  ];

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
                onTap: () {},
                child: DottedBorder(
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
              CustomTextField(
                  labelText: "Product Name", controller: productNameCtrl),
              const SizedBox(height: 10),
              CustomTextField(
                labelText: "Product Description",
                controller: productDescCtrl,
                maxLines: 6,
              ),
              const SizedBox(height: 10),
              CustomTextField(labelText: "Price", controller: proPriceCtrl),
              const SizedBox(height: 10),
              CustomTextField(labelText: "Quantity", controller: proQtyCtrl),
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
              CustomButtom(ontap: () {}, child: const Text("Sell"))
            ],
          ),
        ));
  }
}
