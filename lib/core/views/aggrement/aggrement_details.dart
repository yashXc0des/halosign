// lib/screens/agreement_details_page.dart

import 'package:esign/core/views/aggrement/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/agreement.dart';
import '../../providers/aggrement_provider.dart';


class AgreementDetailsPage extends ConsumerStatefulWidget {
  final Agreement agreement;

  AgreementDetailsPage({required this.agreement});

  @override
  _AgreementDetailsPageState createState() => _AgreementDetailsPageState();
}

class _AgreementDetailsPageState extends ConsumerState<AgreementDetailsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agreement Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${widget.agreement.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Description: ${widget.agreement.description}'),
            SizedBox(height: 10),
            Text('Status: ${widget.agreement.status.description}'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(agreementsProvider.notifier).rejectAgreement(ref as Ref<Object?>, widget.agreement.id);
                    Navigator.pop(context);
                  },
                  child: Text('Reject'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewer(pdfUrl: widget.agreement.pdfUrl!),
                      ),
                    );
                  },
                  child: Text('Open PDF'),
                ),
              ],
            ),
            if (isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
