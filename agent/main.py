#!/usr/bin/env python3
"""
Agent FastAPI - Claude CLIを使用
POST /messages, GET /healthz
"""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import subprocess
import uvicorn

app = FastAPI(title="Agent API")

class MessageRequest(BaseModel):
    text: str

class MessageResponse(BaseModel):
    reply: str
    thread_id: str

@app.post("/messages", response_model=MessageResponse)
async def post_messages(request: MessageRequest):
    """claude -p でリクエストを処理"""
    try:
        # claude -p "request" を実行
        result = subprocess.run(
            ["claude", "-p", request.text],
            capture_output=True,
            text=True,
            timeout=30
        )

        if result.returncode == 0:
            reply = result.stdout.strip()
        else:
            # エラーの場合はエラー内容を返す
            reply = f"Claude error: {result.stderr.strip()}"

        return MessageResponse(
            reply=reply,
            thread_id="fixed-thread-001"
        )

    except subprocess.TimeoutExpired:
        raise HTTPException(status_code=408, detail="Claude command timeout")
    except FileNotFoundError:
        raise HTTPException(status_code=500, detail="Claude command not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal error: {str(e)}")

@app.get("/healthz")
async def healthz():
    """ヘルスチェック"""
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
