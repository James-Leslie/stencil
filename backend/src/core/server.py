from fastapi import FastAPI

from core.api import router

app = FastAPI()

# Every route sits under /api: Vite proxies that prefix in dev and a deployment
# routes it to this service, so the path is the same in both.
app.include_router(router, prefix="/api")
