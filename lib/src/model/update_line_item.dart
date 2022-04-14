//Veryfi imports
import 'package:veryfi_dart/src/model/base_line_item.dart';

class UpdateLineItem extends BaseLineItem {
  int? order;
  String? description;
  double? total;

  Map<String, dynamic> toMap() {
    return {
      if (sku != null) 'sku': sku,
      if (category != null) 'category': category,
      if (tax != null) 'tax': tax,
      if (price != null) 'price': price,
      if (unitOfMeasure != null) 'unit_of_measure': unitOfMeasure,
      if (quantity != null) 'quantity': quantity,
      if (upc != null) 'upc': upc,
      if (taxRate != null) 'tax_rate': taxRate,
      if (discountRate != null) 'discount_rate': discountRate,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (hsn != null) 'hsn': hsn,
      if (section != null) 'section': section,
      if (weight != null) 'weight': weight,
      if (order != null) 'order': order,
      if (description != null) 'description': description,
      if (total != null) 'total': total
    };
  }
}
