import 'package:flutter/material.dart';
import 'package:student_list/models/user.dart';
import 'package:student_list/services/api_service.dart';

class UserEditScreen extends StatefulWidget {
  final User? user;
  const UserEditScreen({super.key, this.user});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final GlobalKey<FormState> formkey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final TextEditingController courseController = TextEditingController();
  bool isLoading = false;
  ApiService apiService = ApiService();

  Future<void> saveUser() async {
    if (!formkey.currentState!.validate() || !mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.user == null) {
        //  add student
        await apiService.createUsers(nameController.text, phoneController.text, );
        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New Student Added Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      } else {

        //  edit student
        await apiService.updateUser(widget.user!.id, nameController.text, phoneController.text);
        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student Updated'),
            backgroundColor: Colors.green,
          ),
        );
      }

      }

      if(mounted){
        Navigator.pop(context, true);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Saving Data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      nameController.text = widget.user!.name;
      phoneController.text = widget.user!.number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add Student' : 'Edit Student'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please Enter a Name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please Enter a Phone Number';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => saveUser(),
                ),
                // const SizedBox(height: 20,),
                // TextFormField(
                //   controller: courseController,
                //   decoration: InputDecoration(
                //     labelText: 'Courses',
                //     prefixIcon: Icon(Icons.menu_book_sharp)
                //   ),
                //   validator: (value) {
                //     if(value == null || value.trim().isEmpty){
                //       return 'Please Enter ';
                //     }
                //   },
                // ),
                const SizedBox(height: 23),
                ElevatedButton(
                  onPressed: isLoading ? null : saveUser,
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.user == null
                              ? 'Add Student'
                              : 'Update Student',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();

  }
}
