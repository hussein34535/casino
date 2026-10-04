import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/features/multi_language.dart';
import 'package:game_show_app/presentation/providers/locale_provider.dart';

class XoLocalePicker extends ConsumerWidget {
  final bool showAsBottomSheet;

  const XoLocalePicker({super.key, this.showAsBottomSheet = true});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: ComicColors.black, width: 3),
      ),
      builder: (_) => const XoLocalePicker(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final locales = XoLocale.supportedLocales;
    final notifier = ref.read(localeProvider.notifier);

    if (showAsBottomSheet) {
      return _buildSheet(context, locales, currentLocale, notifier);
    }

    return _buildList(context, locales, currentLocale, notifier);
  }

  Widget _buildSheet(
    BuildContext context,
    List<XoLocale> locales,
    XoLocale current,
    LocaleNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      decoration: const BoxDecoration(
        color: ComicColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ComicColors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select Language',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: ComicColors.black,
                ),
          ),
          const SizedBox(height: 16),
          Flexible(child: _buildList(context, locales, current, notifier)),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<XoLocale> locales,
    XoLocale current,
    LocaleNotifier notifier,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: locales.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final locale = locales[index];
        final isSelected = locale.code == current.code;
        return ListTile(
          leading: _buildFlagPlaceholder(locale.code),
          title: Text(
            locale.nativeName,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(locale.name),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: ComicColors.green)
              : null,
          onTap: () {
            notifier.setLocale(locale);
            Navigator.maybeOf(context)?.pop();
          },
        );
      },
    );
  }

  Widget _buildFlagPlaceholder(String code) {
    return Container(
      width: 32,
      height: 24,
      decoration: BoxDecoration(
        color: ComicColors.yellow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ComicColors.black, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        code.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: ComicColors.black,
        ),
      ),
    );
  }
}
