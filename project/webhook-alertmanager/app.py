"""
Alertmanager Webhook Receiver
Receives alerts, stores them by team/severity, and forwards to a notification channel.
"""

import json
import logging
import os
from datetime import datetime
from flask import Flask, request, jsonify
from storage import store_alert
from notifier import send_notification

app = Flask(__name__)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


@app.route("/health", methods=["GET"])
def health():
    """Simple health-check endpoint."""
    return jsonify({"status": "ok"}), 200


@app.route("/webhook", methods=["POST"])
def webhook():
    """
    Receive Alertmanager webhook payload.
    Expects Content-Type: application/json.
    """
    # ── 1. Parse body ──────────────────────────────────────────────────────────
    if not request.is_json:
        logger.warning("Received non-JSON request")
        return jsonify({"error": "Content-Type must be application/json"}), 415

    try:
        payload = request.get_json(force=True)
    except Exception as exc:
        logger.error("Failed to parse JSON: %s", exc)
        return jsonify({"error": "Invalid JSON body"}), 400

    if not isinstance(payload, dict):
        return jsonify({"error": "Payload must be a JSON object"}), 400

    alerts = payload.get("alerts")
    if not isinstance(alerts, list) or len(alerts) == 0:
        logger.warning("Payload contains no alerts")
        return jsonify({"error": "'alerts' must be a non-empty list"}), 400

    # ── 2. Process each alert ──────────────────────────────────────────────────
    processed, errors = [], []

    for idx, alert in enumerate(alerts):
        try:
            parsed = _parse_alert(alert, idx)
        except ValueError as exc:
            errors.append({"index": idx, "error": str(exc)})
            logger.warning("Alert %d skipped: %s", idx, exc)
            continue

        # Store
        try:
            store_alert(parsed)
        except Exception as exc:
            logger.error("Failed to store alert %d: %s", idx, exc)
            errors.append({"index": idx, "error": f"Storage error: {exc}"})
            continue

        # Notify
        try:
            send_notification(parsed)
        except Exception as exc:
            # Notification failure is non-fatal – we still return 200
            logger.error("Notification failed for alert %d: %s", idx, exc)

        processed.append(
            {
                "team": parsed["team"],
                "severity": parsed["severity"],
                "alertname": parsed["alertname"],
            }
        )

    # ── 3. Respond ─────────────────────────────────────────────────────────────
    status_code = 200 if processed else 400
    return (
        jsonify(
            {
                "processed": len(processed),
                "skipped": len(errors),
                "details": processed,
                "errors": errors,
            }
        ),
        status_code,
    )


# ── Helpers ────────────────────────────────────────────────────────────────────

def _parse_alert(alert: dict, idx: int) -> dict:
    """Extract and validate fields from a single alert object."""
    if not isinstance(alert, dict):
        raise ValueError("Alert must be a JSON object")

    labels = alert.get("labels") or {}
    annotations = alert.get("annotations") or {}

    team = labels.get("team", "").strip()
    severity = labels.get("severity", "").strip()
    summary = annotations.get("summary", "").strip()
    description = annotations.get("description", "").strip()
    alertname = labels.get("alertname", f"alert_{idx}").strip()

    missing = [f for f, v in [("team", team), ("severity", severity)] if not v]
    if missing:
        raise ValueError(f"Missing required label(s): {', '.join(missing)}")

    return {
        "alertname": alertname,
        "team": team,
        "severity": severity,
        "summary": summary or "(no summary)",
        "description": description or "(no description)",
        "status": alert.get("status", "unknown"),
        "startsAt": alert.get("startsAt", ""),
        "endsAt": alert.get("endsAt", ""),
        "generatorURL": alert.get("generatorURL", ""),
        "labels": labels,
        "annotations": annotations,
        "received_at": datetime.utcnow().isoformat() + "Z",
    }


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)