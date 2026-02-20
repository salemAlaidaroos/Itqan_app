import pandas as pd
import pickle

surah_difficulty_map = {

    'البقرة': 5, 'آل عمران': 5, 'النساء': 5, 'المائدة': 5, 'الأنعام': 4, 'الأعراف': 4,
    
    'الأنفال': 4, 'التوبة': 4, 'يونس': 4, 'هود': 4, 'يوسف': 3, 'الرعد': 4,
    'إبراهيم': 3, 'الحجر': 3, 'النحل': 4, 'الإسراء': 3, 'الكهف': 3, 'مريم': 3,
    'طه': 3, 'الأنبياء': 4, 'الحج': 4, 'المؤمنون': 3, 'النور': 4, 'الفرقان': 3,
    
    'الشعراء': 3, 'النمل': 3, 'القصص': 3, 'العنكبوت': 4, 'الروم': 4, 'لقمان': 3,
    'السجدة': 2, 'الأحزاب': 4, 'سبأ': 3, 'فاطر': 3, 'يس': 2, 'الصافات': 3,
    'ص': 4, 'الزمر': 4, 'غافر': 4, 'فصلت': 3, 'الشورى': 3, 'الزخرف': 3,
    'الدخان': 3, 'الجاثية': 3, 'الأحقاف': 3, 'محمد': 3, 'الفتح': 3, 'الحجرات': 3,
    
    'ق': 3, 'الذاريات': 3, 'الطور': 3, 'النجم': 2, 'القمر': 3, 'الرحمن': 2,
    'الواقعة': 2, 'الحديد': 4, 'المجادلة': 4, 'الحشر': 4, 'الممتحنة': 3, 'الصف': 3,
    'الجمعة': 2, 'المنافقون': 3, 'التغابن': 3, 'الطلاق': 3, 'التحريم': 3, 'الملك': 2,
    
    'القلم': 2, 'الحاقة': 2, 'المعارج': 2, 'نوح': 2, 'الجن': 3, 'المزمل': 3,
    'المدثر': 3, 'القيامة': 2, 'الإنسان': 2, 'المرسلات': 2, 'النبأ': 2, 'النازعات': 2,
    'عبس': 2, 'التكوير': 2, 'الانفطار': 1, 'المطففين': 2, 'الانشقاق': 1, 'البروج': 1,
    'الطارق': 1, 'الأعلى': 1, 'الغاشية': 1, 'الفجر': 2, 'البلد': 1, 'الشمس': 1,
    'الليل': 1, 'الضحى': 1, 'الشرح': 1, 'التين': 1, 'العلق': 1, 'القدر': 1,
    'البينة': 2, 'الزلزلة': 1, 'العاديات': 1, 'القارعة': 1, 'التكاثر': 1, 'العصر': 1,
    'الهمزة': 1, 'الفيل': 1, 'قريش': 1, 'الماعون': 1, 'الكوثر': 1, 'الكافرون': 1,
    'النصر': 1, 'المسد': 1, 'الإخلاص': 1, 'الفلق': 1, 'الناس': 1, 'الفاتحة': 1
}

surah_list = list(surah_difficulty_map.keys())



with open('pythone_model\quran_ai_model.pkl', 'rb') as f:
    artifacts = pickle.load(f)
    model = artifacts['model']
    feature_names = artifacts['features']

print(" Model loaded successfully ")

def test_scenario(surah_name, days, quality, initial, reps, verses, time):
    
    difficulty = surah_difficulty_map.get(surah_name, 3)
    
    input_data = pd.DataFrame([[
        days,
        difficulty,
        quality,
        initial,
        reps,
        verses,
        time
    ]], columns=feature_names)
    
    prob = model.predict_proba(input_data)
    risk_percentage = prob[0][0] * 100 
    
    print("-" * 40)
    print(f"Surah: {surah_name}")
    print(f"Inputs: Days={days}, Quality={quality}, Reps={reps}, Time={time}")
    print(f"Risk Probability: {risk_percentage:.2f}%")
    
    if risk_percentage > 85:
        print("High Risk")
    elif risk_percentage > 50:
        print("Needs Review")
    else:
        print("Safe")


print("\nSTARTING TESTS ")

test_scenario("الملك", days=0, quality=5, initial=1, reps=50, verses=30, time=5)

test_scenario("الكهف", days=7, quality=4, initial=3, reps=15, verses=15, time=10)

test_scenario("البقرة", days=45, quality=2, initial=5, reps=5, verses=10, time=20)

test_scenario("الناس", days=0, quality=5, initial=1, reps=50, verses=6, time=5)




