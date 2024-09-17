import 'package:flutter/material.dart';
import 'package:contato_agenda/helpers/contact_helpers.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  ContactHelpers helper = ContactHelpers();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Contact c = Contact();
    c.id = 2;
    c.name = 'Daniel';
    c.email = 'daniel@gmail.com';
    c.phone = '22222222222222';
    c.img = 'imgteste';

    helper.saveContact(c);

    helper.getAllContacts().then( (list){
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
