import tkinter as tk
from tkinter import messagebox, scrolledtext
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
import imaplib
import email
from email.header import decode_header

# Download necessary NLTK data
nltk.download('punkt')
nltk.download('stopwords')

# Global Variables
stop_words = set(stopwords.words('english'))
model = None  # Placeholder for the trained machine learning model

# Function to preprocess email text
def preprocess_email(text):
    words = word_tokenize(text)
    words = [word.lower() for word in words if word.isalnum() and word not in stop_words]
    return " ".join(words)

# Initialize training data and train the urgency detection model
def train_urgency_model():
    global model
    emails = ["urgent meeting tomorrow", "project deadline", "weekly update", "happy hour invitation"]
    labels = [1, 1, 0, 0]  # 1 for urgent, 0 for non-urgent
    vectorizer = CountVectorizer()
    X = vectorizer.fit_transform([preprocess_email(email) for email in emails])
    model = LogisticRegression()
    model.fit(X, labels)
    return vectorizer

# Function to classify email urgency
def classify_urgency(email_text, vectorizer):
    email_text_processed = preprocess_email(email_text)
    email_vector = vectorizer.transform([email_text_processed])
    prediction = model.predict(email_vector)
    return "Urgent" if prediction[0] == 1 else "Not Urgent"

# GUI and Email Processing Code
class EmailUrgencyApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Email Urgency Detection")
        
        # Initialize UI elements
        self.create_login_interface()

    def create_login_interface(self):
        tk.Label(self.root, text="Email").grid(row=0, column=0)
        self.email_entry = tk.Entry(self.root)
        self.email_entry.grid(row=0, column=1)

        tk.Label(self.root, text="Password").grid(row=1, column=0)
        self.password_entry = tk.Entry(self.root, show="*")
        self.password_entry.grid(row=1, column=1)

        tk.Button(self.root, text="Login", command=self.login).grid(row=2, columnspan=2)
    
    def login(self):
        # Placeholder for actual login code
        email = self.email_entry.get()
        password = self.password_entry.get()
        self.fetch_emails(email, password)
    
    def fetch_emails(self, email, password):
        try:
            # Connect to the IMAP server and fetch emails
            mail = imaplib.IMAP4_SSL("imap.gmail.com")
            mail.login(email, password)
            mail.select("inbox")

            # Search for all emails
            _, search_data = mail.search(None, "ALL")
            email_ids = search_data[0].split()

            # Display each email in the GUI
            for email_id in email_ids[:10]:  # Fetch a sample of 10 emails
                _, msg_data = mail.fetch(email_id, "(RFC822)")
                for response_part in msg_data:
                    if isinstance(response_part, tuple):
                        msg = email.message_from_bytes(response_part[1])
                        email_subject = decode_header(msg["subject"])[0][0]
                        if isinstance(email_subject, bytes):
                            email_subject = email_subject.decode()
                        email_body = ""
                        if msg.is_multipart():
                            for part in msg.walk():
                                content_type = part.get_content_type()
                                if content_type == "text/plain":
                                    email_body = part.get_payload(decode=True).decode()
                        else:
                            email_body = msg.get_payload(decode=True).decode()
                        
                        # Classify the urgency
                        urgency = classify_urgency(email_body, vectorizer)

                        # Display email details
                        self.display_email(email_subject, email_body, urgency)

        except Exception as e:
            messagebox.showerror("Login Error", str(e))

    def display_email(self, subject, body, urgency):
        email_window = tk.Toplevel(self.root)
        email_window.title(subject)
        
        tk.Label(email_window, text=f"Urgency: {urgency}").pack()
        email_text = scrolledtext.ScrolledText(email_window, wrap=tk.WORD, width=60, height=15)
        email_text.insert(tk.END, body)
        email_text.config(state="disabled")
        email_text.pack()

# Run the GUI application
root = tk.Tk()
vectorizer = train_urgency_model()
app = EmailUrgencyApp(root)
root.mainloop()
