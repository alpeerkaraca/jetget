import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/pages/edit_profile.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/pages/edit_product_details.dart';
import 'package:jetget/widgets/MyProducts.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Kullanıcı Profili',
            style: TextStyle(color: Colors.white)),
        backgroundColor: _colorPalette.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser!.uid) // Aktif kullanıcının UID'si
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Yükleniyor...'),
                ],
              ),
            );

          }

          var userData = snapshot.data;
          return ListView(
              padding: const EdgeInsets.only(top: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                profilePicture(image: userData?['profilePhotoUrl']),
                const SizedBox(height: 20),
                buildUserInformations(userData),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _colorPalette.red,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {_auth.signOut();
                        Navigator.popUntil(context, (route) => route.isFirst);},
                      child: const Text(
                        'Çıkış Yap',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
                const SizedBox(height: 20),
                profileStatistics(userData),
                const SizedBox(height: 40),
                MyProducts(),

              ]);
        },
      ),
    );
  }

  profilePicture({String? image}) {
    return Center(
      child: Stack(children: [
        ClipOval(
          child: Material(
            color: Colors.transparent,
            child: Ink.image(
              image: NetworkImage(image ?? ''),
              fit: BoxFit.cover,
              width: 150,
              height: 150,
              child: InkWell(
                onTap: () => {},
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
              iconSize: 1,
              icon: const Icon(Icons.edit, color: Colors.white, size: 25)),
        ));
  }

  profileStatistics(userData) {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildStatistic("Ürün", userData['urun'].toString()),
        SizedBox(height: 24, child: VerticalDivider()),
        buildStatistic("Tedarik", userData?['tedarik'].toString()),
        SizedBox(height: 24, child: Container(child: const VerticalDivider())),
        buildStatistic("Başvuru", userData?['basvuru'].toString()),
      ],
    ));
  }


}

Widget buildStatistic(String title, String? info) {
  return MaterialButton(
    onPressed: () {},
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        Text(
          info!,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ],
    ),
  );
}

Widget buildCircle({
  required Widget child,
  required Color color,
  required double all,
}) {
  return ClipOval(
      child:
          Container(padding: EdgeInsets.all(all), color: color, child: child));
}

Widget buildUserInformations(userData) {

  return Column(
    children: [
      Text(userData?['userName'] ?? ' ',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(userData?['email'] ?? ' ',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey)),
    ],
  );
}
