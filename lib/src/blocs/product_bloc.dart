import 'dart:async';

import 'package:farmers_market/src/models/product.dart';
import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProductBloc {
  final _productName = BehaviorSubject<String>();
  final _unitType = BehaviorSubject<String>();
  final _unitPrice = BehaviorSubject<String>();
  final _availableUnits = BehaviorSubject<String>();
  final _vendorId = BehaviorSubject<String>();
  final _productSaved = PublishSubject<bool>();

  final db = FirestoreService();
  var uuid = Uuid();

  //Get
  Stream<String> get productName => _productName.stream;
  Stream<String> get unitType => _unitType.stream;
  Stream<double> get unitPrice =>
      _unitPrice.stream.transform(validateUnitPrice);
  Stream<int> get availableUnits =>
      _availableUnits.stream.transform(validateAvailableUnits);
  Stream<bool> get isValid => CombineLatestStream.combine4(
      productName, unitType, unitPrice, availableUnits, (a, b, c, d) => true);
  Stream<List<Product>> productsByVendorId(String vendorId) =>
      db.fetchProductByVendorId(vendorId);
  Stream<bool> get productSaved => _productSaved.stream;
  Future<Product> fetchProduct(String productId) => db.fetchProduct(productId);

  //Set
  Function(String) get changeProductName => _productName.sink.add;
  Function(String) get changeUnitType => _unitType.sink.add;
  Function(String) get changeUnitPrice => _unitPrice.sink.add;
  Function(String) get changeAvialableUnits => _availableUnits.sink.add;
  Function(String) get changeVendorId => _vendorId.sink.add;

  dispose() {
    _productName.close();
    _unitType.close();
    _unitPrice.close();
    _availableUnits.close();
    _vendorId.close();
  }

  Future<void> saveProduct() async {
    var product = Product(
      approved: true,
      availableUnits: int.parse(_availableUnits.value),
      productId: uuid.v4(),
      productName: _productName.value.trim(),
      unitPrice: double.parse(_unitPrice.value),
      unitType: _unitType.value,
      vendorId: _vendorId.value,
    );

    return db
        .adProduct(product)
        .then((value) => _productSaved.sink.add(true))
        .catchError((error) => _productSaved.sink.add(false));
  }

  //Validators
  final validateUnitPrice = StreamTransformer<String, double>.fromHandlers(
      handleData: (unitPrice, sink) {
    try {
      sink.add(double.parse(unitPrice));
    } catch (error) {
      sink.addError('Must be a number');
    }
  });

  final validateAvailableUnits = StreamTransformer<String, int>.fromHandlers(
      handleData: (availableUnits, sink) {
    try {
      sink.add(int.parse(availableUnits));
    } catch (error) {
      sink.addError('Must be a whole number');
    }
  });
  final validateProductName = StreamTransformer<String, String>.fromHandlers(
      handleData: (productName, sink) {
    if (productName.length >= 3 && productName.length <= 20) {
      sink.add(productName.trim());
    } else {
      if (productName.length < 3) {
        sink.addError('3 character minimum');
      } else {
        sink.addError('20 characters maximum');
      }
    }
  });
}
