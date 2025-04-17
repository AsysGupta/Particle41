from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def show_info():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    visitor_ip = request.remote_addr
    return jsonify({
        "timestamp": current_time,
        "ip": visitor_ip
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)