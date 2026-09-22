import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import 'auth_dialog.dart';

class Navbar extends StatelessWidget {
  final VoidCallback onBookTestPressed;
  final VoidCallback onPackagesPressed;
  final VoidCallback onTestsPressed;
  final VoidCallback onDoctorsPressed;
  final VoidCallback onViewReportsPressed;

  const Navbar({
    super.key,
    required this.onBookTestPressed,
    required this.onPackagesPressed,
    required this.onTestsPressed,
    required this.onDoctorsPressed,
    required this.onViewReportsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 768;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : (isTablet ? 24 : 16),
        vertical: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Row(
            children: [
              
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE11D74), Color(0xFFFF2E63)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.favorite_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Patho',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E1B4B),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'go',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFE11D74),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Any Lab One Platform',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              
              if (isDesktop) ...[
                _NavLink(title: 'Home', isActive: true, onTap: () {}),
                _NavLink(title: 'Health Tests', onTap: onTestsPressed),
                _NavLink(title: 'Packages', onTap: onPackagesPressed),
                _NavLink(title: 'Health Checkups', onTap: onPackagesPressed),
                _NavLink(title: 'Health Solutions', onTap: onDoctorsPressed),
                _NavLink(title: 'About Us', onTap: () {}),
                const SizedBox(width: 20),
              ],

              
              if (isTablet) ...[
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.headset_mic_rounded, color: Color(0xFF1E1B4B), size: 16),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Help & Support',
                              style: TextStyle(fontSize: 9, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '+91 1234 567 890',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              
              if (isTablet) ...[
                OutlinedButton.icon(
                  onPressed: onViewReportsPressed,
                  icon: const Icon(Icons.receipt_long_rounded, size: 16),
                  label: const Text('Reports & Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E1B4B),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(width: 10),
              ],

              
              Consumer<AppStateProvider>(
                builder: (context, provider, _) {
                  if (provider.isAuthenticated) {
                    final user = provider.currentUser!;
                    return PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'reports') {
                          onViewReportsPressed();
                        } else if (value == 'logout') {
                          provider.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        }
                      },
                      tooltip: 'User Account',
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reports',
                          child: Row(
                            children: [
                              Icon(Icons.history_rounded, size: 18, color: Color(0xFF0D9488)),
                              SizedBox(width: 10),
                              Text('My Bookings & Reports'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout_rounded, size: 18, color: Color(0xFFEF4444)),
                              SizedBox(width: 10),
                              Text('Logout', style: TextStyle(color: Color(0xFFEF4444))),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color(0xFF16A34A),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (isTablet)
                              Text(
                                user.name.split(' ').first,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF15803D)),
                          ],
                        ),
                      ),
                    );
                  }

                  return OutlinedButton.icon(
                    onPressed: () => AuthDialog.show(context),
                    icon: const Icon(Icons.person_outline_rounded, size: 16),
                    label: Text(isTablet ? 'Sign In' : 'Login', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D9488),
                      side: const BorderSide(color: Color(0xFF0D9488), width: 1.4),
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 14 : 10, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),

              
              ElevatedButton.icon(
                onPressed: onBookTestPressed,
                icon: const Icon(Icons.calendar_month_rounded, size: 16),
                label: const Text('Book a Test', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE11D74), 
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 22 : 14,
                    vertical: isDesktop ? 12 : 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                  shadowColor: const Color(0xFFE11D74).withValues(alpha: 0.3),
                ),
              ),

              
              if (!isDesktop) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E1B4B), size: 28),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLink({
    required this.title,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13.5,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? const Color(0xFFE11D74) : const Color(0xFF1E1B4B),
          ),
        ),
      ),
    );
  }
}
