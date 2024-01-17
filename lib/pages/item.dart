import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:jetget/widgets/ItemAppBar.dart';
import 'package:jetget/widgets/ItemBottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';

class ItemPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ItemPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();
    return Scaffold(
      backgroundColor: colorPalette.black.withOpacity(.2),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .doc(product.id)
            .collection("Applicants")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildBody(context, product);
          } else {
            return buildBodyWithApplicants(context, product, snapshot.data!.docs);
          }
        },
      ),
      bottomNavigationBar: ItemBottomNavBar(product: product),
    );
  }

  Widget _buildBody(BuildContext context, product) {
    return ListView(
      children: [
        const ItemAppBar(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Image.network(
            product['productImg'],
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Arc(
          edge: Edge.TOP,
          arcType: ArcType.CONVEY,
          height: 30,
          child: Container(
            width: double.infinity,
            color: ColorPalette().black.withOpacity(.4),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 48,
                bottom: 15,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product['productName'],
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      product['desc'],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBodyWithApplicants(
      BuildContext context, product, List<DocumentSnapshot> applicants) {
    return ListView(
      children: [
        const ItemAppBar(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Image.network(
            product['productImg'],
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Arc(
          edge: Edge.TOP,
          arcType: ArcType.CONVEY,
          height: 30,
          child: Container(
            width: double.infinity,
            color: ColorPalette().black.withOpacity(.4),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 48,
                bottom: 15,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product['productName'],
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      product['desc'],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              'Başvuranlar',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                var applicant = applicants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    NetworkImage(applicant['applierProfilePhotoUrl']),
                  ),
                  title: Text(applicant['applierUserName'],
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
