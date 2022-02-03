import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../provider/item.dart';
import 'package:provider/provider.dart';
import '../provider/items.dart';

class AddNewStoryScreen extends StatefulWidget {
  static const routeName = '/AddNewStory';

  const AddNewStoryScreen({Key? key}) : super(key: key);

  @override
  State<AddNewStoryScreen> createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  final _authorFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  late int selectedRadio;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  var _editedItem = Item(
    author: '',
    category: '',
    content: '',
    id: DateTime.now().toString(),
    startColor: '',
    endColor: '',
    title: '',
  );

  var _initValues = {
    'title': '',
    'content': '',
    'category': '',
    'author': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    selectedRadio = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final itemId = ModalRoute.of(context)?.settings.arguments as String?;
      // ignore: unnecessary_null_comparison
      if (itemId != null) {
        _editedItem =
            Provider.of<Items>(context, listen: false).findById(itemId);
        _initValues = {
          'title': _editedItem.title.toString(),
          'content': _editedItem.content.toString(),
          'category': _editedItem.category.toString(),
          'author': _editedItem.author.toString(),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _authorFocusNode.dispose();

    _contentFocusNode.dispose();

    super.dispose();
  }

    Future<void> _addItem(Item item) {
    const url = 'https://shaparak-732ff.firebaseio.com/items.json';
    return http
        .post(
      Uri.parse(url),
      body: json.encode({
        'title': item.title,
        'author': item.author,
        'content': item.content,
        'id': DateTime.now().toString(),
        'startColor': item.startColor,
        'endColor': item.endColor,
        'category': item.category,
      }),
    )
        .then((response) {
      item = Item(
        title: item.title,
        author: item.author,
        category: item.category,
        content: item.content,
        id: json.decode(response.body)['name'],
        startColor: item.startColor,
        endColor: item.endColor,
      );
    });
  }

  Future<void> _saveForrm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    //await _addItem(_editedItem);
    await _addItem(_editedItem);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedItem.id != null) {
      await Provider.of<Items>(context, listen: false)
          .updateItem(_editedItem.id.toString(), _editedItem);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Add New Story'),
        leading: GestureDetector(
            child: const Text(
              'بروزرسانی',
              style: TextStyle(
                fontFamily: 'Bahijj',
                color: Colors.white,
              ),
            ),
            onTap: _saveForm,
          ),
        actions: [
          

          GestureDetector(
            child: const Text(
              'ذخیره',
              style: TextStyle(
                fontFamily: 'Bahijj',
                color: Colors.white,
              ),
            ),
            onTap: _saveForrm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'عنوان داستان',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'عنوان داستان را وارد کنید';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_authorFocusNode);
                        },
                        onSaved: (value) {
                          _editedItem = Item(
                            title: value,
                            author: _editedItem.author,
                            category: _editedItem.category,
                            content: _editedItem.content,
                            id: _editedItem.id,
                            startColor: _editedItem.startColor,
                            endColor: _editedItem.endColor,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['author'],
                        decoration: const InputDecoration(
                          labelText: 'اسم نویسنده',
                        ),
                        focusNode: _authorFocusNode,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'اسم نویسنده را وارد کنید';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_contentFocusNode);
                        },
                        onSaved: (value) {
                          _editedItem = Item(
                            title: _editedItem.title,
                            author: value,
                            category: _editedItem.category,
                            content: _editedItem.content,
                            id: _editedItem.id,
                            startColor: _editedItem.startColor,
                            endColor: _editedItem.endColor,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['content'],
                        decoration: const InputDecoration(
                          labelText: 'متن داستان',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _contentFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'متن داستان را وارد کنید';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedItem = Item(
                            title: _editedItem.title,
                            author: _editedItem.author,
                            category: _editedItem.category,
                            content: value,
                            id: _editedItem.id,
                            startColor: _editedItem.startColor,
                            endColor: _editedItem.endColor,
                          );
                        },
                      ),
                      Column(
                        children: [
                          Card(
                            child: RadioListTile(
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                setSelectedRadio(val as int);
                                _editedItem = Item(
                                  title: _editedItem.title,
                                  author: _editedItem.author,
                                  category: 'story',
                                  content: _editedItem.content,
                                  id: _editedItem.id,
                                  startColor: Color(0xffFF5B95).toString(),
                                  endColor: Color(0xffF8556D).toString(),
                                );
                              },
                              value: 1,
                              title: const Text('تخیلی'),
                            ),
                          ),
                          Card(
                            child: RadioListTile(
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                setSelectedRadio(val as int);
                                _editedItem = Item(
                                  title: _editedItem.title,
                                  author: _editedItem.author,
                                  category: 'narrative',
                                  content: _editedItem.content,
                                  id: _editedItem.id,
                                  startColor: Color(0xff6DC8F3).toString(),
                                  endColor: Color(0xff73A1F9).toString(),
                                );
                              },
                              value: 2,
                              title: const Text('حکایت'),
                            ),
                          ),
                          Card(
                            child: RadioListTile(
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                setSelectedRadio(val as int);
                                _editedItem = Item(
                                  title: _editedItem.title,
                                  author: _editedItem.author,
                                  category: 'qurani',
                                  content: _editedItem.content,
                                  id: _editedItem.id,
                                  startColor: Color(0xffD76EF5).toString(),
                                  endColor: Color(0xff8F7AFE).toString(),
                                );
                              },
                              value: 3,
                              title: const Text('قرآنی'),
                            ),
                          ),
                          Card(
                            child: RadioListTile(
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                setSelectedRadio(val as int);
                                _editedItem = Item(
                                  title: _editedItem.title,
                                  author: _editedItem.author,
                                  category: 'success',
                                  content: _editedItem.content,
                                  id: _editedItem.id,
                                  startColor: Color(0xffFFB157).toString(),
                                  endColor: Color(0xffFFA057).toString(),
                                );
                              },
                              value: 4,
                              title: const Text('از تاریخ'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
