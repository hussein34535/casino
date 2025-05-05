import 'package:flutter/material.dart';
import 'package:game_show_app/screens/game_select_screen.dart'; // سنحتاجها لاحقًا للانتقال
import 'package:provider/provider.dart'; // سنحتاجها لاحقًا
import 'package:game_show_app/providers/game_provider.dart'; // سنحتاجها لاحقًا
import 'package:shared_preferences/shared_preferences.dart'; // استيراد الحزمة

// مفاتيح لتخزين البيانات في SharedPreferences
// const String _prefsPlayerCountKey = 'player_count';
const String _prefsPlayerNamesKey = 'player_names';
const int _maxPlayers = 10; // Define max players
const int _minPlayers = 1; // Define min players

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _nameControllers = [];
  final List<GlobalKey<FormFieldState>> _formKeys = [];
  bool _isLoading = true; // لتتبع حالة تحميل البيانات المحفوظة

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // تحميل البيانات عند بدء التشغيل
  }

  @override
  void dispose() {
    // التخلص من الـ controllers لمنع تسرب الذاكرة
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- دالة تحميل البيانات المحفوظة ---
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    // Remove loading player count
    // final savedPlayerCount = prefs.getInt(_prefsPlayerCountKey);
    final savedPlayerNames = prefs.getStringList(_prefsPlayerNamesKey);

    // Initialize controllers based on saved names
    if (savedPlayerNames != null && savedPlayerNames.isNotEmpty) {
      // Ensure not exceeding max players limit on load
      int countToLoad = savedPlayerNames.length > _maxPlayers
          ? _maxPlayers
          : savedPlayerNames.length;
      for (int i = 0; i < countToLoad; i++) {
        _addPlayerField(
            initialValue: savedPlayerNames[i], triggerSetState: false);
      }
    } else {
      // Add minimum number of fields if nothing is saved
      for (int i = 0; i < _minPlayers; i++) {
        _addPlayerField(triggerSetState: false);
      }
    }

    setState(() {
      _isLoading = false; // تم الانتهاء من التحميل
    });
  }

  // --- دالة حفظ البيانات ---
  Future<void> _saveCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames =
        _nameControllers.map((controller) => controller.text.trim()).toList();
    // Remove saving player count
    // await prefs.setInt(_prefsPlayerCountKey, _selectedPlayerCount);
    await prefs.setStringList(_prefsPlayerNamesKey, playerNames);
  }

  // Simplified function to add a player field
  void _addPlayerField(
      {String initialValue = '', bool triggerSetState = true}) {
    if (_nameControllers.length >= _maxPlayers)
      return; // Don't add if max reached

    final controller = TextEditingController(text: initialValue);
    _nameControllers.add(controller);
    _formKeys.add(GlobalKey<FormFieldState>());
    if (triggerSetState && mounted) {
      setState(() {});
    }
  }

  // Function to remove a player field
  void _removePlayerField(int index) {
    if (_nameControllers.length <= _minPlayers)
      return; // Don't remove if min reached

    // Dispose controller before removing
    _nameControllers[index].dispose();
    _nameControllers.removeAt(index);
    _formKeys.removeAt(index);
    if (mounted) {
      setState(() {});
    }
  }

  // دالة للتحقق من أن جميع حقول الأسماء مملوءة
  bool _areAllNamesEntered() {
    if (_nameControllers.isEmpty) return false;
    return _nameControllers
        .every((controller) => controller.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme

    // عرض مؤشر تحميل أثناء قراءة البيانات المحفوظة
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('كازينو الألعاب - إعداد اللعبة'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Determine current player count from controllers list
    int currentPlayerCount = _nameControllers.length;

    return Scaffold(
      // Add background gradient
      // Make sure your main.dart theme has appropriate primary/secondary colors
      extendBodyBehindAppBar: true, // Allow body to go behind AppBar
      appBar: AppBar(
        title: const Text('كازينو الألعاب - إعداد اللعبة'),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove AppBar shadow
        centerTitle: true,
      ),
      body: Container(
        // Remove background gradient decoration
        child: SafeArea(
          // Ensure content is below status bar etc.
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // REMOVE Player Count Chips Section
                  /*
                  const Text(
                    'اختر عدد اللاعبين:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70), // Adjusted style
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Wrap(
                      spacing: 10.0, // Horizontal space between chips
                      runSpacing: 8.0, // Vertical space between lines
                      alignment: WrapAlignment.center,
                      children: _playerCountOptions.map((count) {
                        return ChoiceChip(
                          label: Text('$count'),
                          selected: _selectedPlayerCount == count,
                          onSelected: (bool selected) {
                            if (selected) {
                              setState(() {
                                _selectedPlayerCount = count;
                                _updateNameControllers(); // Update fields when count changes
                              });
                            }
                          },
                          selectedColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(
                            color: _selectedPlayerCount == count
                                ? theme.colorScheme.onPrimary
                                : theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor:
                              theme.colorScheme.surfaceVariant.withOpacity(0.5),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  */

                  // --- Name Input Fields Title ---
                  const Text(
                    'أدخل أسماء اللاعبين (1-10):', // Show range
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  // --- Name Input Fields List ---
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentPlayerCount, // Use dynamic count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        // Use Row to add remove button
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: _formKeys[index],
                                controller: _nameControllers[index],
                                decoration: InputDecoration(
                                  hintText:
                                      'اسم اللاعب ${index + 1}', // Use hintText instead
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor:
                                      theme.inputDecorationTheme.fillColor ??
                                          theme.colorScheme.surface
                                              .withOpacity(0.15),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 12.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال اسم اللاعب';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction
                                    .next, // Always next, add button handles submit implicitly
                              ),
                            ),
                            // Add Remove Button (conditionally)
                            if (currentPlayerCount > _minPlayers)
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline,
                                    color: theme.colorScheme.error
                                        .withOpacity(0.8)),
                                tooltip: 'إزالة اللاعب ${index + 1}',
                                onPressed: () {
                                  _removePlayerField(index);
                                },
                              )
                            else // Keep space consistent even if button hidden
                              const SizedBox(
                                  width: 48), // Match IconButton width approx
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  // --- Add Player Button ---
                  if (currentPlayerCount < _maxPlayers)
                    TextButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('إضافة لاعب'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      onPressed: () {
                        _addPlayerField();
                      },
                    ),
                  const SizedBox(height: 30),
                  // --- Start Game Button ---
                  ElevatedButton(
                    onPressed: _areAllNamesEntered()
                        ? () async {
                            await _saveCurrentData();
                            final playerNames = _nameControllers
                                .map((controller) => controller.text.trim())
                                .toList();
                            Provider.of<GameProvider>(context, listen: false)
                                .setPlayers(playerNames);

                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GameSelectScreen()),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30)), // Rounded corners
                      backgroundColor: _areAllNamesEntered()
                          ? theme.colorScheme.primary
                          : Colors
                              .grey.shade600, // Different color when enabled
                      foregroundColor: _areAllNamesEntered()
                          ? theme.colorScheme.onPrimary
                          : Colors.grey.shade400,
                    ),
                    child: const Text('ابدأ اللعبة'),
                  ),
                  const SizedBox(height: 20), // Add some bottom space
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
