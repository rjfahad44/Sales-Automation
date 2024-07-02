

class Cart{
  int itemID = 0, quantity = 0, chemistID = 0, minimumQuantity = 0;
  double unitPrice = 0.0, discountValue =0.0, vat =0.0, mrp = 0.0;
  String itemName = "", chemistName = "", discountName ="", discountType ="";

  Cart(
      this.itemID,
      this.itemName,
      this.unitPrice,
      this.quantity,
      this.discountName,
      this.discountType,
      this.discountValue,
      this.minimumQuantity,
      this.vat,
      this.mrp,
      this.chemistName,
      this.chemistID
      );

  double calculateFinalPrice(double productPrice, int quantity, double discountValue, String discountType, int minimumQuantity) {
    double totalPrice = productPrice * quantity;
    if (totalPrice < minimumQuantity) return totalPrice;
    return discountType.toLowerCase() == 'percentage'
        ? totalPrice * (1 - discountValue / 100)
        : totalPrice - discountValue;
  }

  double calculateDiscount(double productPrice, int quantity, double discountValue, String discountType, int minimumQuantity){
    double totalPrice = productPrice * quantity;
    if (totalPrice >= minimumQuantity) {
      return discountType.toLowerCase() == 'percentage'
        ? totalPrice * (1 - discountValue / 100)
        : totalPrice - discountValue;
    } else {
      return 0;
    }
  }
}