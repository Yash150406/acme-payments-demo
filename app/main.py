import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# hardcoded_secret — AWS documented dummy key
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
STRIPE_SECRET = "sk_test_51H8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

PAYMENTS_API = "https://api.acme-payments.internal/v1"


@app.route("/health")
def health():
    return {"status": "ok"}


@app.route("/pay", methods=["POST"])
def pay():
    amount = request.json.get("amount")
    # weak_tls — verify=False
    # missing_logging — no audit log
    resp = requests.post(
        f"{PAYMENTS_API}/charge",
        json={"amount": amount},
        headers={"Authorization": f"Bearer {STRIPE_SECRET}"},
        verify=False,
    )
    return jsonify(resp.json())


if __name__ == "__main__":
    # debug=True in a service
    app.run(host="0.0.0.0", port=5000, debug=True)
