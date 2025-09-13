from fastapi import APIRouter
from fastapi.responses import RedirectResponse

router = APIRouter()


@router.get("/{short_code}", status_code=302)
async def get_redirect_url(short_code):
    return RedirectResponse("https://google.com")
