"""
End-to-end tests for VouDeQue backend.
Run with: pytest tests/test_e2e.py -v
"""
import requests


class TestAuth:
    def test_anonymous_auth_returns_token(self, api_url):
        r = requests.post(f"{api_url}/api/v1/auth/anonymous")
        assert r.status_code == 200
        data = r.json()
        assert "user_id" in data
        assert "token" in data
        assert data["user_id"].startswith("anon:")
        assert isinstance(data["token"], str) and len(data["token"]) > 10

    def test_unauthenticated_access_fails(self, api_url):
        # Generate look without token
        r = requests.post(f"{api_url}/api/v1/looks/generate", json={"occasion": "casual"})
        assert r.status_code == 401

        # Vote without token
        r = requests.post(f"{api_url}/api/v1/looks/vote", json={"look_id": "fake-id"})
        assert r.status_code == 401

        # Delete account without token
        r = requests.delete(f"{api_url}/api/v1/users/me")
        assert r.status_code == 401

        # Invalid token
        headers = {"Authorization": "Bearer invalidtoken"}
        r = requests.post(f"{api_url}/api/v1/looks/generate", headers=headers, json={"occasion": "casual"})
        assert r.status_code == 401


class TestLooks:
    def test_generate_look_authenticated(self, api_url, auth_token):
        headers = {"Authorization": f"Bearer {auth_token}"}
        payload = {
            "occasion": "date",
            "style_notes": "algo romântico e confortável",
        }
        r = requests.post(f"{api_url}/api/v1/looks/generate", headers=headers, json=payload)
        assert r.status_code == 200
        data = r.json()
        assert "id" in data
        assert "description" in data
        assert "items" in data
        assert isinstance(data["items"], list)
        assert data["occasion"] == "date"
        assert data["votes"] == 0
        # Verify item schema
        for item in data["items"]:
            assert "name" in item
            assert "category" in item
            assert "color" in item
            assert "reason" in item

    def test_feed_returns_list(self, api_url):
        r = requests.get(f"{api_url}/api/v1/looks/feed")
        assert r.status_code == 200
        data = r.json()
        assert isinstance(data, list)

    def test_feed_pagination(self, api_url):
        r = requests.get(f"{api_url}/api/v1/looks/feed?limit=5&offset=0")
        assert r.status_code == 200
        data = r.json()
        assert isinstance(data, list)
        assert len(data) <= 5


class TestVotes:
    def test_vote_look(self, api_url, auth_token):
        headers = {"Authorization": f"Bearer {auth_token}"}

        # First generate a look
        r = requests.post(
            f"{api_url}/api/v1/looks/generate",
            headers=headers,
            json={"occasion": "festa"},
        )
        assert r.status_code == 200
        look_id = r.json()["id"]

        # Vote on it
        r = requests.post(f"{api_url}/api/v1/looks/vote", headers=headers, json={"look_id": look_id})
        assert r.status_code == 200
        data = r.json()
        assert data["success"] is True
        assert data["votes"] >= 1

    def test_vote_same_look_twice_fails(self, api_url, auth_token):
        headers = {"Authorization": f"Bearer {auth_token}"}

        # Generate a look
        r = requests.post(
            f"{api_url}/api/v1/looks/generate",
            headers=headers,
            json={"occasion": "trabalho"},
        )
        assert r.status_code == 200
        look_id = r.json()["id"]

        # First vote
        r = requests.post(f"{api_url}/api/v1/looks/vote", headers=headers, json={"look_id": look_id})
        assert r.status_code == 200

        # Second vote should fail
        r = requests.post(f"{api_url}/api/v1/looks/vote", headers=headers, json={"look_id": look_id})
        assert r.status_code == 400
        assert "já votou" in r.json()["detail"].lower() or "already voted" in r.json()["detail"].lower()

    def test_vote_nonexistent_look_fails(self, api_url, auth_token):
        headers = {"Authorization": f"Bearer {auth_token}"}
        r = requests.post(
            f"{api_url}/api/v1/looks/vote",
            headers=headers,
            json={"look_id": "nonexistent-look-id"},
        )
        assert r.status_code == 404


class TestChallenges:
    def test_daily_challenge_returns_challenge(self, api_url):
        r = requests.get(f"{api_url}/api/v1/challenges/daily")
        assert r.status_code == 200
        data = r.json()
        assert "id" in data
        assert "title" in data
        assert "description" in data
        assert "theme" in data
        assert "ends_at" in data
        assert "participants" in data

    def test_ranking_returns_list(self, api_url):
        r = requests.get(f"{api_url}/api/v1/challenges/ranking")
        assert r.status_code == 200
        data = r.json()
        assert isinstance(data, list)


class TestAccountDeletion:
    def test_delete_account(self, api_url):
        # Create a fresh user
        r = requests.post(f"{api_url}/api/v1/auth/anonymous")
        assert r.status_code == 200
        token = r.json()["token"]
        headers = {"Authorization": f"Bearer {token}"}

        # Delete account
        r = requests.delete(f"{api_url}/api/v1/users/me", headers=headers)
        assert r.status_code == 200
        assert r.json()["success"] is True

        # Subsequent requests with the same token should fail
        r = requests.post(
            f"{api_url}/api/v1/looks/generate",
            headers=headers,
            json={"occasion": "casual"},
        )
        assert r.status_code == 401
