from flask import Flask, request, jsonify
import pickle
import pandas as pd
from data.surah_data import surah_difficulty_map

app = Flask(__name__)

with open('pythone_model/quran_ai_model.pkl', 'rb') as f:
    artifacts = pickle.load(f)
    model = artifacts['model']
    feature_names = artifacts['features']

print("✅ Model Loaded Successfully")

@app.route('/predict_risk', methods=['POST'])
def predict_risk():
    data = request.get_json()
    surah_name = data.get('surah_name', 'الفاتحة')
    global_difficulty = surah_difficulty_map.get(surah_name, 3)

    input_data = pd.DataFrame([[
        data['days_since_last_review'],
        global_difficulty,
        data['last_review_quality'],
        data['initial_difficulty'],
        data['repetition_count'],
        data['verse_count'],
        data['avg_time_taken']
    ]], columns=feature_names)

    prob = model.predict_proba(input_data)
    
    risk_percentage = float(prob[0][0]) * 100 
    
    easy_surahs = ['الفيل','الفاتحة', 'الناس', 'الفلق', 'الإخلاص', 'الكوثر', 'النصر', 'قريش', 'العصر', 'المسد','الكافرون','الزلزلة']
    
    if surah_name in easy_surahs:
        if risk_percentage > 55:
            print(f"⚠️ Adjusting {surah_name} from: {risk_percentage:.1f}% to 48.0%")
            risk_percentage = 48.0 

    return jsonify({
        'status': 'success',
        'surah': surah_name,
        'risk_percentage': round(float(risk_percentage), 1) 
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)