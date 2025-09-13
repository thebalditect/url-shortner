from fastapi import FastAPI
from app.features.shorten_url.endpoint import router as shorten_url_router
from app.features.get_redirect_url.endpoint import router as get_redirect_url

app = FastAPI()
app.include_router(shorten_url_router)
app.include_router(get_redirect_url)