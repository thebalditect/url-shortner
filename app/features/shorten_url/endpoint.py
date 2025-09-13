from pydantic import BaseModel, HttpUrl
from fastapi import APIRouter
import secrets

class ShortenUrlRequest(BaseModel):
    original_url: HttpUrl

class ShortenUrlResponse(BaseModel):
    short_code: str
    shortened_url: HttpUrl

async def shorten(original_url: str):
    short_code = secrets.token_urlsafe(6)
    shortened_url = f"http://localhost:8000/{short_code}"
    return {"short_code": short_code, "shortened_url": shortened_url}


router = APIRouter()

@router.post("/urls/shorten", response_model= ShortenUrlResponse, status_code= 201)
async def shorten_url(request: ShortenUrlRequest):
    return await shorten(request.original_url)


