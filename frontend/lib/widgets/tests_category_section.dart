import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class TestsCategorySection extends StatelessWidget {
  final Function(String categorySlug)? onSelectCategory;

  const TestsCategorySection({super.key, this.onSelectCategory});

  static final Map<String, _CategoryVisual> _visuals = {
    'bone': _CategoryVisual(
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFFE11D48),
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=200&auto=format&fit=crop&q=80',
    ),
    'diabetes': _CategoryVisual(
      icon: Icons.bloodtype_rounded,
      color: Color(0xFFEF4444),
      imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=200&auto=format&fit=crop&q=80',
    ),
    'gastro': _CategoryVisual(
      icon: Icons.restaurant_rounded,
      color: Color(0xFFF97316),
      imageUrl: 'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=200&auto=format&fit=crop&q=80',
    ),
    'gynae': _CategoryVisual(
      icon: Icons.pregnant_woman_rounded,
      color: Color(0xFFEC4899),
      imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=200&auto=format&fit=crop&q=80',
    ),
    'heart': _CategoryVisual(
      icon: Icons.favorite_rounded,
      color: Color(0xFFDC2626),
      imageUrl: 'https://images.unsplash.com/photo-1559757175-5700dde675bc?w=200&auto=format&fit=crop&q=80',
    ),
    'kidney': _CategoryVisual(
      icon: Icons.water_drop_rounded,
      color: Color(0xFF0284C7),
      imageUrl: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=200&auto=format&fit=crop&q=80',
    ),
    'liver': _CategoryVisual(
      icon: Icons.shield_rounded,
      color: Color(0xFFD97706),
      imageUrl: 'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=200&auto=format&fit=crop&q=80',
    ),
    'prostate': _CategoryVisual(
      icon: Icons.person_rounded,
      color: Color(0xFF7C3AED),
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=200&auto=format&fit=crop&q=80',
    ),
    'thyroid': _CategoryVisual(
      icon: Icons.flash_on_rounded,
      color: Color(0xFF0D9488),
      imageUrl: 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=200&auto=format&fit=crop&q=80',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 768;

    return Container(
      width: double.infinity,
      color: Colors.white,
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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tests by Category',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A8A), 
                      letterSpacing: -0.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, color: Color(0xFFDC2626), size: 14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.testCategories.map((cat) {
                    final isSelected = state.selectedTestCategory == cat.slug;
                    final visual = _visuals[cat.slug] ?? _CategoryVisual(
                      icon: Icons.medical_services_rounded,
                      color: const Color(0xFFE11D48),
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          state.setTestCategory(cat.slug);
                          onSelectCategory?.call(cat.slug);
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Column(
                          children: [
                            
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? const Color(0xFFFDE8EC) : Colors.white,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFDC2626) : const Color(0xFFF87171),
                                  width: isSelected ? 3 : 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withValues(alpha: isSelected ? 0.25 : 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (visual.imageUrl != null)
                                      Image.network(
                                        visual.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Center(
                                          child: Icon(visual.icon, color: visual.color, size: 34),
                                        ),
                                      ),
                                    Container(
                                      color: isSelected
                                          ? const Color(0xFFDC2626).withValues(alpha: 0.2)
                                          : Colors.black.withValues(alpha: 0.15),
                                    ),
                                    Center(
                                      child: Icon(
                                        visual.icon,
                                        color: Colors.white,
                                        size: 28,
                                        shadows: const [
                                          Shadow(color: Colors.black45, blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat.name,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                color: isSelected ? const Color(0xFFDC2626) : const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryVisual {
  final IconData icon;
  final Color color;
  final String? imageUrl;

  _CategoryVisual({required this.icon, required this.color, this.imageUrl});
}
