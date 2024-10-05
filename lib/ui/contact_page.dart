import 'dart:io';

import 'package:flutter/material.dart';
import '../helpers/contact_helpers.dart';

class ContactPage extends StatefulWidget {
  Contact? contact;

  ContactPage({super.key, this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  late Contact? _editedContact;

  bool _userEdited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if( widget.contact == null ){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editedContact!.name!;
      _emailController.text = _editedContact!.email!;
      _phoneController.text = _editedContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (context){
        _requestPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Novo Contato"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact!.name != null && _editedContact!.name!.isNotEmpty ){
              Navigator.pop(context,_editedContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.save),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding:const EdgeInsets.all(10.0),
            child: Column(
              children: [
                GestureDetector(
                  child:  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("imagens/person.png"),
                        )),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(
                      labelText: "Nome"
                  ),
                  onChanged: (text){
                    _userEdited = true;
                    _editedContact!.name = text;
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: "Email"
                  ),
                  onChanged: (text){
                    _userEdited = true;
                    _editedContact!.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      labelText: "Phone"
                  ),
                  onChanged: (text){
                    _userEdited = true;
                    _editedContact!.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if( _userEdited ){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Text("Atençao"),
              backgroundColor: Colors.white,
              content: const Text("Deseja perder as alteraçoes?"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Não")
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Sim")
                )
              ],
            );
          }
      );
      return Future.value(true);
    }else{
      return Future.value(true);
    }
  }
}
