import tkinter as tk
from tkinter import scrolledtext, messagebox, filedialog
import threading
import sys
import io
import time
import asyncio
import websocket
import time
import json
from myconverter.parser import Parser 
# from myconverter.parser2 import Parser 

# Thread-Handler
code_thread = None
stop_flag = False
conv_action = Parser()

# ---------------- WebSocket Funktion ----------------
def send_to_websocket(message):
    """Sendet eine Nachricht über WebSocket zu ws://localhost:8765."""
    while True:
        try:
            ws = websocket.create_connection("ws://localhost:8765")
            converted_msg  = conv_action.parse(message)
            print(f"Converted message: {converted_msg}")
            for msg in converted_msg:
                ws.send(f"{msg[0]} , {msg[1]}")
                time.sleep(0.1)
                response = ws.recv()  # status information from player
            ws.close()
            try:
                data = json.loads(response)
            except json.JSONDecodeError:
                data = response  # fallback to raw msg
            print(f"Received from client: {data}")
        except Exception as e:
            print(f"WebSocket-Fehler: {e}")

# ---------------- Code Ausführen ----------------
def run_code():
    global stop_flag
    stop_flag = False
    code = code_field.get("1.0", tk.END)
    send_to_websocket(code)

def play():
    global code_thread
    if code_thread and code_thread.is_alive():
        messagebox.showwarning("Hinweis", "Code läuft bereits!")
        return
    code_thread = threading.Thread(target=run_code)
    code_thread.start()

def stop():
    global stop_flag
    stop_flag = True
    messagebox.showinfo("Stopp", "Programm wurde angehalten (falls Code darauf reagiert).")

# ---------------- Funktionen Speichern ----------------
def save_functions():
    code = func_field.get("1.0", tk.END).strip()
    if not code:
        messagebox.showwarning("Leeres Feld", "Es gibt keinen Code zu speichern!")
        return
    # Direkt in funktionen.txt speichern
    filepath = "funktionen.txt"
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(code)
    messagebox.showinfo("Erfolg", f"Funktionen gespeichert in {filepath}")

# ---------------- Funktionen Laden ----------------
def load_functions():
    filepath = "funktionen.txt"
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            code = f.read()
        func_field.delete("1.0", tk.END)
        func_field.insert(tk.END, code)
        messagebox.showinfo("Erfolg", f"Funktionen aus {filepath} geladen")
    except FileNotFoundError:
        messagebox.showwarning("Fehler", f"{filepath} existiert nicht")

# ---------------- GUI aufbauen ----------------
root = tk.Tk()
root.title("Code Runner mit Funktionen")

# ----- Code-Feld -----
tk.Label(root, text="Hauptcode").pack()
code_field = scrolledtext.ScrolledText(root, width=80, height=15)
code_field.pack(padx=10, pady=5, expand=True, fill='both')

frame_code = tk.Frame(root)
frame_code.pack()
play_btn = tk.Button(frame_code, text="Play", command=play, bg="lightgreen")
play_btn.pack(side=tk.LEFT, padx=5)
stop_btn = tk.Button(frame_code, text="Stop", command=stop, bg="lightcoral")
stop_btn.pack(side=tk.LEFT, padx=5)

# ----- Funktionen-Feld -----
tk.Label(root, text="Funktionen").pack(pady=(10,0))

func_field = scrolledtext.ScrolledText(root, width=80, height=10)
func_field.pack(padx=10, pady=5, expand=True, fill='both')

frame_code2 = tk.Frame(root)
frame_code2.pack()
save_btn = tk.Button(frame_code2, text="Save Funktionen", command=save_functions, bg="lightblue")
save_btn.pack(side=tk.LEFT, padx=5, pady=5)
load_btn = tk.Button(frame_code2, text="Load Funktionen", command=load_functions, bg="lightyellow")
load_btn.pack(side=tk.LEFT, padx=5, pady=5)

root.mainloop()
