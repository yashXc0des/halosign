import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/aggrement_provider.dart';
import '../aggrement/aggrement_details.dart';


class AgreementListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(agreementsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Agreements')),
      body: ListView.builder(
        itemCount: agreements.length,
        itemBuilder: (context, index) {
          final agreement = agreements[index];
          return Card(
            child: ListTile(
              title: Text(agreement.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgreementDetailsPage(agreement: agreement),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
