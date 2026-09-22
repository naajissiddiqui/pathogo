import 'package:flutter/material.dart';

class LabPartnersSection extends StatelessWidget {
  const LabPartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 768;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
        vertical: 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Our Trusted Lab Partners',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          'View All Partners',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, color: Color(0xFF2563EB), size: 14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              Row(
                children: [
                  
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.chevron_left_rounded, color: Color(0xFF64748B), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),

                  
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const [
                          _MaxHealthCard(),
                          SizedBox(width: 14),
                          _MetropolisCard(),
                          SizedBox(width: 14),
                          _RedcliffeCard(),
                          SizedBox(width: 14),
                          _Tata1mgCard(),
                          SizedBox(width: 14),
                          _ThyrocareCard(),
                          SizedBox(width: 14),
                          _AgilusCard(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _MaxHealthCard extends StatelessWidget {
  const _MaxHealthCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.local_hospital_rounded, color: Color(0xFF38BDF8), size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'MAX',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                  height: 1.0,
                ),
              ),
              Text(
                'Healthcare',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _MetropolisCard extends StatelessWidget {
  const _MetropolisCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'METROPOLIS',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF059669), 
              letterSpacing: 0.8,
              height: 1.1,
            ),
          ),
          Text(
            'The Pathology Specialist',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}


class _RedcliffeCard extends StatelessWidget {
  const _RedcliffeCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.biotech_rounded, color: Color(0xFFE11D48), size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Redcliffe',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFE11D48),
                  height: 1.0,
                ),
              ),
              Text(
                'Labs',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _Tata1mgCard extends StatelessWidget {
  const _Tata1mgCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'TATA',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '1mg',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _ThyrocareCard extends StatelessWidget {
  const _ThyrocareCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Thyrocare',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A8A),
              letterSpacing: -0.2,
              height: 1.1,
            ),
          ),
          Text(
            'Tests you can trust',
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}


class _AgilusCard extends StatelessWidget {
  const _AgilusCard();

  @override
  Widget build(BuildContext context) {
    return _BasePartnerContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'agilus',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0284C7),
                  height: 1.0,
                ),
              ),
              Text(
                'diagnostics',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Row(
            children: const [
              Icon(Icons.chevron_right_rounded, color: Color(0xFF0284C7), size: 16),
              Icon(Icons.chevron_right_rounded, color: Color(0xFFF97316), size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _BasePartnerContainer extends StatelessWidget {
  final Widget child;

  const _BasePartnerContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
