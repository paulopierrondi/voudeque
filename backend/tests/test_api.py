import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_health():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

@pytest.mark.asyncio
async def test_generate_look():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Authenticate first
        auth_resp = await ac.post("/api/v1/auth/anonymous")
        assert auth_resp.status_code == 200
        token = auth_resp.json()["token"]
        
        response = await ac.post("/api/v1/looks/generate", 
            headers={"Authorization": f"Bearer {token}"},
            json={
                "occasion": "date",
                "style_notes": "algo romantico"
            })
    assert response.status_code == 200
    data = response.json()
    assert "id" in data
    assert "description" in data
    assert "items" in data

@pytest.mark.asyncio
async def test_feed():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/api/v1/looks/feed")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
