import 'package:cached_network_image/cached_network_image.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:flutter/material.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  // ignore: library_private_types_in_public_api
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 0.7,
            child: Container(
               padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
              child: Hero(
                tag: widget.product.codigoArticulo.toString(),
                child: CachedNetworkImage(
                          imageUrl: '$imagenesUrl/${widget.product.imageUrl}',
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          placeholder: (context, url) => const Image(
                            image: AssetImage('assets/Logo.png'),
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),                         
                        ),
              ),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
      //  Row(
      //    mainAxisAlignment: MainAxisAlignment.center,
      //    children: [
      //      ...List.generate(widget.product.images.length,
      //          (index) => buildSmallProductPreview(index)),
      //    ],
      //  )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: CachedNetworkImage(
                        imageUrl: widget.product.images[index],
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/Logo.png'),
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        ),                         
                      ),
      ),
    );
  }
}
