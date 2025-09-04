import tkinter as tk
from tkinter import scrolledtext, messagebox
import threading
import sys
import io
import time
import asyncio
import websocket
import json
from myconverter.parser import Parser 

# Thread-Handler
code_thread = None
stop_flag = False

conv_action = Parser()

def send_to_websocket(message):
    """Sendet eine Nachricht über WebSocket zu ws://localhost:8765."""
    try:
        ws = websocket.create_connection("ws://localhost:8765")

        converted_msg  = conv_action.parse(message)
        print(f"Converted message: {converted_msg}")
        for msg in converted_msg:
            ws.send(f"{msg[0]} , {msg[1]}")  # send action multiple times
            time.sleep(0.1)  
            response = ws.recv() # status information from player
            # time.sleep(0.1)  
            

        ws.close()
        try:
            data = json.loads(response)
        except json.JSONDecodeError:
            data = response  # fallback to raw msg if not JSON
        print(f"Received from client: {data}")
                
        ws.close()
    except Exception as e:
        print(f"WebSocket-Fehler: {e}")  # Optional: Fehler in Konsole ausgeben

def run_code():
    global stop_flag
    stop_flag = False
    
    # Code aus dem Textfeld holen
    code = text_field.get("1.0", tk.END)
    
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

# GUI aufbauen
root = tk.Tk()
root.title("Code Runner")

text_field = scrolledtext.ScrolledText(root, width=80, height=20)
text_field.pack(padx=10, pady=10)

frame = tk.Frame(root)
frame.pack()

play_btn = tk.Button(frame, text="Play", command=play, bg="lightgreen")
play_btn.pack(side=tk.LEFT, padx=5)

stop_btn = tk.Button(frame, text="Stop", command=stop, bg="lightcoral")
stop_btn.pack(side=tk.LEFT, padx=5)

root.mainloop()
