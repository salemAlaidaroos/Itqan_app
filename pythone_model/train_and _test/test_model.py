import pandas as pd
import pickle
from data.surah_data import surah_difficulty_map


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

