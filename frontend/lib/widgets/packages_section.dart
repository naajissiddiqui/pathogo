import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/package_model.dart';
import '../providers/app_state_provider.dart';
import 'package_card.dart';

class PackagesSection extends StatelessWidget {
  final Function(HealthPackage) onSelectPackage;

  const PackagesSection({
    super.key,
    required this.onSelectPackage,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
        vertical: 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              _buildPage1Packages(context, state),

              const SizedBox(height: 48),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 36),

              
              _buildPage2PopularPackages(context, state, isDesktop, isTablet),

              const SizedBox(height: 40),

              
              _buildWhyChooseSection(isDesktop, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildPage1Packages(BuildContext context, AppStateProvider state) {
    final popularPkgs = state.packages.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.push_pin_rounded, color: Color(0xFFE11D74), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Popular Health Packages',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFE11D74),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Comprehensive Health Packages',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Stay healthy with our carefully curated test packages.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'View All Packages',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFE11D74)),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, color: Color(0xFFE11D74), size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: popularPkgs.map((pkg) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _Page1PackageCard(
                  package: pkg,
                  onBook: () => onSelectPackage(pkg),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  
  Widget _buildPage2PopularPackages(
    BuildContext context,
    AppStateProvider state,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Packages',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A8A), 
                letterSpacing: -0.5,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'See all',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFDC2626)),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, color: Color(0xFFDC2626), size: 14),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: state.packageCategories.map((cat) {
              final isSelected = state.selectedPackageCategory == cat.slug;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => state.setPackageCategory(cat.slug),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE11D48) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFE11D48) : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        
        if (state.isLoadingPackages)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: Color(0xFFE11D48)),
            ),
          )
        else if (state.packages.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('No health packages found in this category.', style: TextStyle(color: Color(0xFF64748B))),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.packages.map((pkg) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 300,
                    height: 310,
                    child: PackageCard(
                      package: pkg,
                      onBookPressed: () => onSelectPackage(pkg),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  
  Widget _buildWhyChooseSection(bool isDesktop, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B), 
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(isDesktop ? 28 : 20),
      child: isDesktop
          ? Row(
              children: [
                
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Why Choose Pathogo?',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'With advanced technology, certified labs, and a team of experts, we ensure accurate reports delivered quickly and securely.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _StatCol(icon: Icons.person_add_alt_1_rounded, value: '10K+', label: 'Happy Patients'),
                      _StatCol(icon: Icons.biotech_rounded, value: '15+', label: 'Lab Partners'),
                      _StatCol(icon: Icons.verified_rounded, value: '98%', label: 'Accuracy Rate'),
                      _StatCol(icon: Icons.support_agent_rounded, value: '24/7', label: 'Support'),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE11D74), Color(0xFFBE123C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Limited Time Health Offer!',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Flat 20% OFF + Get 10% Cashback on all Test packs',
                                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Offer valid till 31st December 2026',
                                style: TextStyle(fontSize: 8, color: Color(0xFFFFD1DC)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why Choose Pathogo?',
                  style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'With advanced technology, certified labs, and a team of experts, we ensure accurate reports delivered quickly and securely.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.4),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _StatCol(icon: Icons.person_add_alt_1_rounded, value: '10K+', label: 'Patients'),
                    _StatCol(icon: Icons.biotech_rounded, value: '15+', label: 'Labs'),
                    _StatCol(icon: Icons.verified_rounded, value: '98%', label: 'Accuracy'),
                    _StatCol(icon: Icons.support_agent_rounded, value: '24/7', label: 'Support'),
                  ],
                ),
              ],
            ),
    );
  }
}


class _Page1PackageCard extends StatelessWidget {
  final HealthPackage package;
  final VoidCallback onBook;

  const _Page1PackageCard({required this.package, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 275,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: package.isPopular ? const Color(0xFFE11D74).withValues(alpha: 0.6) : const Color(0xFFE2E8F0),
          width: package.isPopular ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (package.isPopular)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D74),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
              ),
            ),
          Text(
            package.name,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            package.description,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${package.discountPrice.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (package.originalPrice > package.discountPrice)
                    Text(
                      '₹${package.originalPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Book Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCol({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE11D74), size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'Outfit',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
