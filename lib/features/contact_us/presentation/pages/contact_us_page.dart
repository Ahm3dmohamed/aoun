import 'package:aoun/features/contact_us/presentation/widgets/build_contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun/core/extensions/localization_extension.dart';
import 'package:aoun/features/splash/splash_background.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.l10n.contactUs,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.howCanWeHelp,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Reach out to us through any of the channels below.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 30.h),
              buildContactCard(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'ahmedmohamed@aoun.com',
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              buildContactCard(
                context,
                icon: Icons.phone_outlined,
                title: 'Phone',
                subtitle: "+201032695113",
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              buildContactCard(
                context,
                icon: Icons.location_on_outlined,
                title: 'Headquarters',
                subtitle: 'Cairo, Egypt',
                onTap: () {},
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.l10n.send,
                  style: const TextStyle(
                    color: Color(0xFF00838F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
