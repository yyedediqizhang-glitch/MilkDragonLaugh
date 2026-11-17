import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../util/app_theme.dart';
import '../../util/locale_controller.dart';
import 'setting_page_controller.dart';

/// Settings page: language, storage used, app version and the clear action.
class SettingPageView extends StatefulWidget {
  const SettingPageView({super.key});

  @override
  State<SettingPageView> createState() => _SettingPageViewState();
}

class _SettingPageViewState extends State<SettingPageView> {
  final SettingPageController _controller = SettingPageController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _languageLabel(AppLocalizations l10n, Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return l10n.languageChinese;
      case 'ja':
        return l10n.languageJapanese;
      default:
        return l10n.languageEnglish;
    }
  }

  Future<bool> _askConfirmation({
    required String title,
    required String body,
    required String confirmLabel,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppPalette palette = context.palette;
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: palette.danger),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return answer ?? false;
  }

  Future<void> _clearData() async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // Challenge requirement: double confirmation before wiping the data.
    final bool first = await _askConfirmation(
      title: l10n.clearDataTitle,
      body: l10n.clearDataBody,
      confirmLabel: l10n.clearAction,
    );
    if (!first || !mounted) {
      return;
    }

    final bool second = await _askConfirmation(
      title: l10n.confirmClearTitle,
      body: l10n.confirmClearBody,
      confirmLabel: l10n.clearAction,
    );
    if (!second || !mounted) {
      return;
    }

    await _controller.clearData();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.dataCleared)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final AppPalette palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: <Widget>[
              _SectionTitle(label: l10n.languageSection),
              _Tile(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.translate_rounded,
                      size: 20,
                      color: palette.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.language)),
                    DropdownButton<Locale>(
                      value: _controller.locale,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(12),
                      items: LocaleController.supportedLocales
                          .map(
                            (Locale locale) => DropdownMenuItem<Locale>(
                              value: locale,
                              child: Text(_languageLabel(l10n, locale)),
                            ),
                          )
                          .toList(),
                      onChanged: (Locale? locale) {
                        if (locale != null) {
                          _controller.setLocale(locale);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _SectionTitle(label: l10n.dataSection),
              _Tile(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.storage_rounded, size: 20, color: palette.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.storageTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: palette.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _controller.isLoading
                                ? '...'
                                : l10n.storageUsed(_controller.formattedSize),
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _controller.isLoading ? null : _clearData,
                icon: const Icon(Icons.delete_forever_outlined),
                label: Text(l10n.clearData),
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.danger,
                  side: BorderSide(
                    color: palette.danger.withValues(alpha: 0.35),
                  ),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              _SectionTitle(label: l10n.aboutSection),
              _Tile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.appTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: palette.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.version(_controller.versionLabel),
                      style: TextStyle(fontSize: 12, color: palette.muted),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.aboutBody,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          color: context.palette.muted,
        ),
      ),
    );
  }
}
