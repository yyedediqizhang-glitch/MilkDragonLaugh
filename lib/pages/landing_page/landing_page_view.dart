import 'package:material_ui/material_ui.dart';

import '../../components/primary_button.dart';
import '../home_page/home_page_view.dart';
import 'landing_page_controller.dart';

/// First screen of the app: branding plus a single call to action.
class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  final LandingPageController _controller = LandingPageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openHome() async {
    await _controller.start();
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HomePageView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF2F6FED), Color(0xFF1B4BC4)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 3),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'EDU SNAP',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your campus life, in one snap.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xCCFFFFFF),
                  ),
                ),
                const Spacer(flex: 4),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return PrimaryButton(
                      label: 'Get Started',
                      icon: Icons.arrow_forward_rounded,
                      isLoading: _controller.isStarting,
                      onPressed: _openHome,
                    );
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  'Session 1 demo · Flutter + MVC',
                  style: TextStyle(fontSize: 12, color: Color(0x99FFFFFF)),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
