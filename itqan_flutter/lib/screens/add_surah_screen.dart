import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import '../services/database_service.dart';
import 'surah_detail_screen.dart';

class AddSurahScreen extends StatefulWidget {
  const AddSurahScreen({super.key});

  @override
  State<AddSurahScreen> createState() => _AddSurahScreenState();
}

class _AddSurahScreenState extends State<AddSurahScreen> {
  int _selectedSurah = 1;
  int _startAyah = 1;
  int _endAyah = 7;
  final _db = DatabaseService();

  bool _isSaving = false;

  void _updateAyahs() {
    setState(() {
      _startAyah = 1;
      _endAyah = quran.getVerseCount(_selectedSurah);
    });
  }

  void _save(bool startNow) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    int newSurahId = await _db.addSurah(
      surahNumber: _selectedSurah,
      startVerse: _startAyah,
      endVerse: _endAyah,
    );

    if (!mounted) return;

    if (startNow) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SurahDetailScreen(
            surahNumber: _selectedSurah,
            isMemorizationMode: true,
            surahId: newSurahId,
            currentRepeats: 0,
          ),
        ),
      );
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تمت إضافة الورد للجدول بنجاح ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F2854);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: mainColor),
            onPressed: _isSaving ? null : () => Navigator.pop(context),
          ),
          title: const Text("حفظ ورد جديد",
              style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("اختر السورة", style: TextStyle(color: Colors.grey)),
              _simpleDropdown(
                value: _selectedSurah,
                maxItems: 114,
                label: (val) => "${val}. ${quran.getSurahNameArabic(val)}",
                onChanged: _isSaving
                    ? null
                    : (val) {
                        setState(() {
                          _selectedSurah = val!;
                          _updateAyahs();
                        });
                      },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("من آية",
                            style: TextStyle(color: Colors.grey)),
                        _simpleDropdown(
                          value: _startAyah,
                          maxItems: quran.getVerseCount(_selectedSurah),
                          label: (val) => "$val",
                          onChanged: _isSaving
                              ? null
                              : (val) => setState(() => _startAyah = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("إلى آية",
                            style: TextStyle(color: Colors.grey)),
                        _simpleDropdown(
                          value: _endAyah,
                          maxItems: quran.getVerseCount(_selectedSurah),
                          label: (val) => "$val",
                          onChanged: _isSaving
                              ? null
                              : (val) => setState(() => _endAyah = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFBDE8F5).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text("عدد الآيات: ${_endAyah - _startAyah + 1}",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainColor)),
                    Text("سورة ${quran.getSurahNameArabic(_selectedSurah)}",
                        style: const TextStyle(color: mainColor)),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isSaving ? null : () => _save(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text("ابدأ الحفظ الآن",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _isSaving ? null : () => _save(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: mainColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("إضافة للجدول",
                    style: TextStyle(
                        fontSize: 18,
                        color: mainColor,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleDropdown({
    required int value,
    required int maxItems,
    required String Function(int) label,
    required void Function(int?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          items: List.generate(maxItems, (index) {
            int num = index + 1;
            return DropdownMenuItem(value: num, child: Text(label(num)));
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
