import 'package:blocform/src/bloc/provider.dart';
import 'package:blocform/src/models/product_model.dart';
import 'package:blocform/src/providers/product_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final productsProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: _createProductList(context),
      ),
      floatingActionButton: _createButton(context),
    );
  }

  _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white, size: 30.0,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0)
      ),
      elevation: 5.0,
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        Navigator.pushNamed(context, 'product');
      });
  }

  _createProductList(BuildContext context) {
    return FutureBuilder(
      future: productsProvider.getProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if(snapshot.hasData) {

          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) =>_item(context, products[index]),
          );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _item(BuildContext context, Product product) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async { 
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¿Eliminar producto "${product.productName}"?', style: TextStyle(fontSize: 18.0),),
            actions: <Widget>[
              FlatButton( onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancelar"), textColor: Colors.deepPurple,),
          FlatButton( onPressed: () => Navigator.of(context).pop(true),
            child: Text("Eliminar"), textColor: Colors.deepPurple),
        ],
          )
        );
      },
      background: Container(
        color: Colors.red[700],
        ),
      onDismissed: (direction) => productsProvider.deleteProduct(product.id),
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: _getImage(context,product),
      )
    );
  }

  _getImage(BuildContext context, Product product) {

    final card = Container(
      child: Column(
        children: <Widget>[
          (product.photoUrl == null)
            ? Image(image: AssetImage('assets/no_image.png'))
            : Hero(
              tag: product.id,
              child: FadeInImage(placeholder: AssetImage('assets/loading.gif'),
                image: NetworkImage(product.photoUrl),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.fitHeight),
            ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            title: Row(
              children: <Widget>[
                Text('${product.productName}', style: TextStyle(fontSize: 18)),
                Expanded(child: Container()),
                Text('${product.price} USD', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
              ],
            )
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
      child: card,
    );
  }
}