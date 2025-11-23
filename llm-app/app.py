from flask import Flask, request, jsonify, render_template_string
import subprocess

app = Flask(__name__)

HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>LLM Chat Assistant</title>
    <style>
        body { font-family: Arial; max-width: 800px; margin: 50px auto; padding: 20px; }
        .header { display: flex; align-items: center; gap: 15px; margin-bottom: 20px; }
        .logo { height: 50px; }
        h1 { color: #333; margin: 0; }
        #chat-box { border: 1px solid #ddd; padding: 20px; height: 400px; overflow-y: auto; background: #f9f9f9; margin-bottom: 20px; }
        .message { margin: 10px 0; padding: 10px; border-radius: 5px; }
        .user { background: #e3f2fd; text-align: right; }
        .assistant { background: #fff; }
        input[type="text"] { width: 80%; padding: 10px; font-size: 16px; }
        button { padding: 10px 20px; font-size: 16px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        button:hover { background: #45a049; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="header">
        <a href="https://ksug.ai" target="_blank"><img src="https://ksug.ai/assets/Logo-C22ZmRMJ.jpg" alt="KSUG.AI" class="logo"></a>
        <h1>🤖 LLM Chat Assistant by <a href="https://ksug.ai" target="_blank" style="color: #4CAF50; text-decoration: none;">KSUG.AI</a></h1>
    </div>
    <div id="chat-box"></div>
    <input type="text" id="prompt" placeholder="Ask me anything..." onkeypress="if(event.key==='Enter') sendMessage()">
    <button onclick="sendMessage()">Send</button>
    <script>
        function sendMessage() {
            const prompt = document.getElementById('prompt').value;
            if (!prompt) return;
            
            const chatBox = document.getElementById('chat-box');
            chatBox.innerHTML += `<div class="message user"><strong>You:</strong> ${prompt}</div>`;
            document.getElementById('prompt').value = '';
            
            fetch('/chat', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({prompt: prompt})
            })
            .then(r => r.json())
            .then(data => {
                chatBox.innerHTML += `<div class="message assistant"><strong>Assistant:</strong><br><pre>${data.response}</pre></div>`;
                chatBox.scrollTop = chatBox.scrollHeight;
            });
        }
    </script>
</body>
</html>
'''

@app.route('/', methods=['GET'])
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    prompt = data.get('prompt', '')
    
    response = f"AI Assistant: {prompt}\n\n"
    
    # Vulnerable: Execute commands from prompt
    if "execute:" in prompt.lower():
        command = prompt.split("execute:", 1)[1].strip()
        try:
            result = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
            response += f"Output:\n{result}"
        except Exception as e:
            response += f"Error: {str(e)}"
    else:
        response += "I can help you! Use 'execute: <command>' to run commands."
    
    return jsonify({"response": response})

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
