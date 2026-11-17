import 'package:material_ui/material_ui.dart';

import 'setting_page_controller.dart';

/// Settings page. Kept simple in Session 2, it gets extended later.
class SettingPageView extends StatelessWidget {
  const SettingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingPageController controller = SettingPageController();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE3E9F4)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6FED),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      controller.appName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14223B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version ${SettingPageController.appVersion}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7A88A3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9AA7BF),
            ),
          ),
          const SizedBox(height: 10),
          const _InfoTile(
            icon: Icons.menu_book_outlined,
            title: 'Journal app',
            subtitle: 'Built with Flutter and the MVC structure from the workshop.',
          ),
          const SizedBox(height: 10),
          _InfoTile(
            icon: Icons.timeline_rounded,
            title: 'Current build',
            subtitle: controller.buildInfo,
          ),
          const SizedBox(height: 24),
          const Text(
            'More settings (theme, local storage, language) are added in the '
            'next sessions.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E9F4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: const Color(0xFF2F6FED)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14223B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF7A88A3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
