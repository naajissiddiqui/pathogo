import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  final VoidCallback onBookHomeCollection;
  final VoidCallback onPackagesClicked;
  final VoidCallback onBookingsClicked;
  final VoidCallback onReportsClicked;

  const FooterSection({
    super.key,
    required this.onBookHomeCollection,
    required this.onPackagesClicked,
    required this.onBookingsClicked,
    required this.onReportsClicked,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFFDC2626), 
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Expanded(flex: 4, child: _buildBrandCol()),
                        const SizedBox(width: 32),

                        
                        Expanded(flex: 3, child: _buildQuickLinksCol()),
                        const SizedBox(width: 32),

                        
                        Expanded(flex: 3, child: _buildWhyPathogoCol()),
                        const SizedBox(width: 32),

                        
                        Expanded(flex: 4, child: _buildActionCol()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandCol(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildQuickLinksCol()),
                            Expanded(child: _buildWhyPathogoCol()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildActionCol(),
                      ],
                    ),

              const SizedBox(height: 32),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 20),

              
              _buildKeywordsDirectory(),

              const SizedBox(height: 24),
              const Divider(color: Colors.white24, thickness: 1),
              const SizedBox(height: 16),

              
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  const Text(
                    '© Pathogo.in 2021-2026. All Rights Reserved',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  if (isTablet)
                    Wrap(
                      spacing: 8,
                      children: const [
                        Text('Cancellation & Refund Policy', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        Text('|', style: TextStyle(fontSize: 11, color: Colors.white38)),
                        Text('Terms & Conditions', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        Text('|', style: TextStyle(fontSize: 11, color: Colors.white38)),
                        Text('Privacy Policy', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite_rounded, color: Color(0xFFDC2626), size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Pathogo.in',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'ANY TEST ANY LAB',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white70,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your one-stop solution for convenient booking, painless sample collection, and timely reporting of all medical tests.',
          style: TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
        ),
        const SizedBox(height: 14),

        
        Row(
          children: const [
            Icon(Icons.phone_rounded, color: Colors.white, size: 14),
            SizedBox(width: 8),
            Text(
              'Contact us: 012 44 55 0000',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: const [
            Icon(Icons.mail_outline_rounded, color: Colors.white, size: 14),
            SizedBox(width: 8),
            Text(
              'Reach out: customercare@pathogo.in',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLinksCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _FooterLink(label: 'Packages', onTap: onPackagesClicked),
        _FooterLink(label: 'Bookings', onTap: onBookingsClicked),
        _FooterLink(label: 'Reports', onTap: onReportsClicked),
        _FooterLink(label: 'Register your lab with us', onTap: () {}),
      ],
    );
  }

  Widget _buildWhyPathogoCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _FooterLink(label: 'Why Pathogo', onTap: () {}),
        _FooterLink(label: 'Blog & Health Tips', onTap: () {}),
        _FooterLink(label: 'Contact Support', onTap: () {}),
        _FooterLink(label: 'Press Coverage', onTap: () {}),
        _FooterLink(label: 'Sitemap', onTap: () {}),
      ],
    );
  }

  Widget _buildActionCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        ElevatedButton.icon(
          onPressed: onBookHomeCollection,
          icon: const Icon(Icons.home_work_rounded, size: 16, color: Color(0xFFDC2626)),
          label: const Text(
            'Book a Home Collection',
            style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
        const SizedBox(height: 16),

        
        Row(
          children: const [
            _SocialIcon(icon: Icons.facebook_rounded),
            SizedBox(width: 8),
            _SocialIcon(icon: Icons.chat_rounded),
            SizedBox(width: 8),
            _SocialIcon(icon: Icons.smart_display_rounded),
            SizedBox(width: 8),
            _SocialIcon(icon: Icons.camera_alt_rounded),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Download our mobile app',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'GET IT ON Google Play',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordsDirectory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _DirectoryRow(
          title: 'Popular Health Tests: ',
          content: 'Complete Blood Count (CBC) | Urine Routine (RU) | Liver Function Test (LFT) | Kidney Function Test (KFT) Basic | Vitamin B12 | Vitamin D3 25Hydroxy | Glycosylated Hemoglobin (HbA1c) | Blood Sugar Random (BSR) | Lipid Profile (Heart Risk) | Thyroid Profile Total (T3, T4, TSH) View More',
        ),
        SizedBox(height: 10),
        _DirectoryRow(
          title: 'Popular Health Packages: ',
          content: 'Basic Health Package | Advanced Health Package | Couple\'s Health Package | Basic Health Monitoring Tests (Fasting) | Comprehensive Health Package (Female) | Comprehensive Health Package (Male) | Corporate Health Package | Executive Health Package Male | KidCare Essential Package View More',
        ),
        SizedBox(height: 10),
        _DirectoryRow(
          title: 'Diagnostic Centers List: ',
          content: 'Diagnostic centres in New Delhi | Diagnostic centres in Gurgaon | Diagnostic centres in Sohna | Diagnostic centres in Ferozepur Jhirka | Diagnostic centres in Dharuhera | Diagnostic centres in Nuh | Diagnostic centres in Narnaul | Diagnostic centres in Faridabad | Diagnostic centres in Gurugram View More',
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('- ', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}

class _DirectoryRow extends StatelessWidget {
  final String title;
  final String content;

  const _DirectoryRow({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 10.5, color: Colors.white70, height: 1.5),
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
          TextSpan(text: content),
        ],
      ),
    );
  }
}
