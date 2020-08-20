import 'dart:io';

import 'package:blocform/src/models/product_model.dart';
import 'package:blocform/src/providers/product_provider.dart';
import 'package:blocform/utils/utils.dart' as utils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productProvider = new ProductProvider();
  File photo;
  final picker = ImagePicker();

  Product product;
  bool _save = false;

  @override
  Widget build(BuildContext context) {
    final Product prodData = ModalRoute.of(context).settings.arguments;
    prodData != null ? product = prodData : product = new Product();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPhoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _nameField(),
                _priceField(),
                _setAvailable(),
                _addProductButton(),
              ],
            )
          )
        )
      ),
      
    );
  }

  _nameField() {
    return TextFormField(
      initialValue: product.productName,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => product.productName = value,
      validator: (value) => (value.length > 3) ? null : 'Ingrese un nombre valido',
    );
  }

  _priceField() {
    return TextFormField(
      initialValue: product.price.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (String value) => product.price = double.parse(value),
      validator: (value) => utils.isValidNumber(value) ? null : 'Ingrese un precio válido',
    );
  }

  _addProductButton() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: RaisedButton.icon(
        //margin: EdgeInsets.only(top: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0)
        ),
        color: Colors.deepPurple,
        textColor: Colors.white,
        icon: Icon(Icons.save),
        label: Text('Guardar'),
        onPressed: _save ? null : _submit,
      ),
    );
  }

  _setAvailable() {
    return SwitchListTile(
      activeColor: Colors.deepPurple,
      value: product.available,
      title: Text('Disponible'),
      onChanged: (value) => setState((){
        product.available = value;
      }),
    );
  }

  void _submit() async {
    String message;
    if(!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() { _save = true; });

    if(photo != null) {
      product.photoUrl = await productProvider.uploadImage(photo);
    }

    if(product.id != null) {
      productProvider.updateProduct(product);
      message = 'Producto actualizado correctamente';
    } else {
      productProvider.createProduct(product);
      message = 'Producto guardado correctamente';
    }
    

    showSnackBar(message);
  }

  showSnackBar(message) {
    final snackbar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)), 
      backgroundColor: Colors.deepPurple,
      duration: Duration(milliseconds: 1000)
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

    Future.delayed(const Duration(seconds: 1), ()=>Navigator.pop(context));
  }

  _selectPhoto() async => _getImage(ImageSource.gallery);
    
  _takePhoto() async => _getImage(ImageSource.camera);
 
Future _getImage(ImageSource origin) async{
 final pickedFile = await picker.getImage(source: origin);
    if(pickedFile != null){
      product.photoUrl = null;
    }
    setState(() {
      try {
        photo = File(pickedFile?.path) != null ? File(pickedFile.path) : null;
      } catch (e) {

      }
      
    });
}

Widget _showPhoto(){
 
 if (product.photoUrl != null) {
      return Hero(
          tag: product.id,
          child: Image(
          image: NetworkImage(product.photoUrl),
          height: 150.0,
        ),
      );
    } else {
      if( photo != null ){
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 150.0,
        );
      }
      return Image.asset('assets/no_image.png', height: 150.0,);
    }
 
}

}