import 'package:flutter/material.dart';

class OnboardingLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final String primaryText;
  final VoidCallback? onPrimary;
  final Widget? secondaryButton;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const OnboardingLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.primaryText,
    required this.onPrimary,
    this.secondaryButton,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// TITLE
              Text(
                title,
                style: titleStyle??(
                  TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  )
                ),
              ),

              const SizedBox(height: 12),

              /// SUBTITLE
              Text(subtitle, style: TextStyle(fontSize: 26)),

              const SizedBox(height: 32),

              /// BODY (nội dung chính)
              body,

              /// Đẩy button xuống đáy
              const Spacer(),

              /// BUTTON
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                ), // 👈 nâng lên khỏi đáy
                child: Row(
                  children: [
                    if (secondaryButton != null) secondaryButton!,
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade200,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: onPrimary,
                          child: Text(
                            primaryText,
                            style: TextStyle(fontSize: 18),
                            // style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
