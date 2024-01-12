import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get _user => _auth.currentUser!;
  final ColorPalette _colorPalette = ColorPalette();

  late final TextEditingController _userNameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();

  final Uint8List _profilePicture = Uint8List(0);


  @override
  void initState() {
    super.initState();
    getCurrentUserInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
        const Text("Profil Düzenle", style: TextStyle(color: Colors.white)),
        backgroundColor: _colorPalette.black,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Users').doc(_user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var userData = snapshot.data;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              profilePicture(image: userData?['profilePhotoUrl']),
              const SizedBox(height: 20),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kullanıcı Adı',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _userNameController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-posta',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                  onPressed: handleSaveClick, child: const Text('Save'))
            ],
          );
        },
      ),
    );
  }

  Future getCurrentUserInfos() async {
    return FirebaseFirestore.instance.collection('Users').where(
        'uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((
        value) =>
    {
      _userNameController.text = value.docs[0]['userName'],
      _emailController.text = value.docs[0]['email'],
    });
  }

  Future<void> handleSaveClick() async {
    await _firestore.collection('Users').doc(_user.uid).update({
      'userName': _userNameController.text,
      'email': _emailController.text,
    }).then((value) =>
    { ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    )});
  }



  profilePicture({String? image}) {
    return Center(
      child: Stack(children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(image!),
              fit: BoxFit.cover,
              width: 150,
              height: 150,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 0, right: 4, child: editProfileButton(_colorPalette.aqua)),
      ]),
    );
  }

  Widget editProfileButton(Color color) {
    return buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: .5,
          child: IconButton(
              onPressed: handlePhotoUploadAndSave,
              iconSize: 1,
              icon: const Icon(Icons.add_a_photo, color: Colors.white, size: 25)),
        ));
  }

  Widget buildCircle({
    required Widget child,
    required Color color,
    required double all,
  }) =>
      ClipOval(
          child: Container(
              padding: EdgeInsets.all(all), color: color, child: child));

  handlePhotoUploadAndSave() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('ProfilePictures/$fileName');

      UploadTask uploadTask = storageReference.putData(
          (await pickedFile!.readAsBytes()).buffer.asUint8List());
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

      await _firestore.collection('Users').doc(_user.uid).update({
        'profilePhotoUrl': downloadURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully')),
      );
    } catch (error) {
      print('Error uploading photo: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile photo')),
      );
    }
  }
}


