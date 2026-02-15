import pandas as pd
import pickle
from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier
import os
from sklearn.metrics import accuracy_score, classification_report
data_path="pythone_model\data\quran_dataset_final.csv"
df = pd.read_csv(data_path)

X = df.drop('next_review_outcome', axis=1)
y = df['next_review_outcome']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = XGBClassifier(
    n_estimators=100,      
    learning_rate=0.05,   
    max_depth=3,          
    subsample=0.8,        
    use_label_encoder=False,
    eval_metric='logloss',
    random_state=42
)

print("starting the training ... ")
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)

print("-" * 30)
print(f"the model trained sucssefuly")
print(f"Accuracy: {accuracy * 100:.2f}%")
print("-" * 30)
print("the report: ")
print(classification_report(y_test, y_pred))


artifacts = {
    'model': model,
    'features': X.columns.tolist()
}

with open('quran_ai_model.pkl', 'wb') as f:
    pickle.dump(artifacts, f)

print("the file downloaded in the file : 'quran_ai_model.pkl'")