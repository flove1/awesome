import sys, subprocess
from gpt4free import gptworldAi

if len(sys.argv) > 1:
    if sys.argv[1] == "--short":
        prompt = "Keep your answers short. " + subprocess.check_output(['xclip', '-o'], text=True)
    elif sys.argv[1] == "--academic":
        prompt = "Next questions are a test, send me only answers: " + subprocess.check_output(['xclip', '-o'], text=True)
    else:
        prompt = sys.argv[1]
else:
    prompt = subprocess.check_output(['xclip', '-o'], text=True)

for chunk in gptworldAi.Completion.create(prompt):
    print(chunk, end="", flush=True)
print()