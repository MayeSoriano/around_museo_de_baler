import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: Text(
          'Terms and Conditions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),

      /// Body
      body: SfPdfViewer.asset(
        "assets/docs/terms-and-conditions.pdf", // Load PDF from assets
        canShowScrollHead: false, // Optionally disable scroll head
        enableDoubleTapZooming: true, // Enable zooming
      ),
    );
  }
}

