#!/bin/bash
set -e
cd /workspaces/Model-Deployment

source backend/.venv/bin/activate

cd backend
python app.py &
BACKEND_PID=$!

cd ../frontend
python -m streamlit run app.py \
--server.address 0.0.0.0 \
--server.port 8501 &
FRONTEND_PID=$!

trap 'kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true' EXIT
#Make the Streamlit port public after startup
(sleep 15; gh codespace ports visibility 8501:public) > /tmp/superkart-port.log 2>&1 &
wait
