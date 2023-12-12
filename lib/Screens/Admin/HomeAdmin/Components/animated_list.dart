import 'package:flutter/material.dart';

class AnimatedListSample extends StatefulWidget {
  const AnimatedListSample({super.key});

  @override
  AnimatedListSampleState createState() => AnimatedListSampleState();
}

class AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  void _insertItem() {
    final int index = _items.length;
    _items.insert(index, 'Item ${index + 1}');
    _listKey.currentState?.insertItem(index);
  }

  // ignore: unused_element
  void _removeItem(int index) {
    final String removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
    );
  }

  Widget _buildItem(String item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(Tween(begin: const Offset(1, 0), end: const Offset(0, 0))),
      child: Card(
        child: ListTile(
          title: Text(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animated List Demo'),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_items[index], animation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}