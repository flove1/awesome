import sys, subprocess
import g4f

if len(sys.argv) > 1:
    if sys.argv[1] == "--short":
        prompt = "Keep your answers short. " + subprocess.check_output(['xclip', '-o'], text=True)
    elif sys.argv[1] == "--academic":
        prompt = "Next questions are a test, send me only answers: " + subprocess.check_output(['xclip', '-o'], text=True)
    else:
        prompt = sys.argv[1]
else:
    prompt = subprocess.check_output(['xclip', '-o'], text=True)

response = g4f.ChatCompletion.create(
    model="gpt-3.5-turbo",
    provider=g4f.Provider.You,
    messages=[{"role": "user", "content": prompt}]
)

print(response)
