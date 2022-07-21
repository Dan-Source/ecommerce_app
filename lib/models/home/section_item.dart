class SectionItem {
  dynamic image;
  String? product = 'sem produtos';

  SectionItem({required this.image, this.product});

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    if (map['product'] != null){
      product = map['product'] as String;
    }
  }

  Map<String, dynamic> toMap() {
    return {'image': image, 'product': product};
  }

  SectionItem clone() {
    return SectionItem(image: image, product: product);
  }

  @override
  String toString() {
    return 'SectionItem{image: $image, product: $product}';
  }
}
