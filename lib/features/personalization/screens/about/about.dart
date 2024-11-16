import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/texts/section_heading.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MAppBar(
        title: Text(
          'About',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),

      /// Body
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MAppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App Description
              SectionHeading(title: 'About the App'),
              SizedBox(height: 8),
              Text(
                'This app serves as your ultimate guide to the Museo de Baler, featuring not only its rich history, captivating exhibits, and exciting events but also offering immersive AR experiences that bring the museum to life. Explore stunning tourist locations and enjoy interactive content that enhances your visit, making every moment at the museum truly unforgettable.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: 16),

              /// Version Information
              SectionHeading(title: 'Version'),
              SizedBox(height: 8),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              SizedBox(height: 16),

              /// Data Source Acknowledgment
              SectionHeading(title: 'Data Source'),
              SizedBox(height: 8),
              Text(
                'Data and content provided by the Municipal Tourism Office of Baler, Aurora.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: 16),

              /// Developer Information
              SectionHeading(title: 'Developed By'),
              SizedBox(height: 8),
              Text(
                'ARound Museo de Baler Team\nEmail: around.museodebaler@gmail.com',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
