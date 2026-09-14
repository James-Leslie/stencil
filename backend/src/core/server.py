from fastapi import FastAPI

from core.api import router

app = FastAPI()

# Every route sits under /api: vercel.json routes that prefix to this service,
# and Vite proxies it in dev, so the path is the same in both.
app.include_router(router, prefix="/api")
