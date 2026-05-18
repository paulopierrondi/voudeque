# VouDeQue Backend Tests

## E2E Tests

Run the full end-to-end test suite:

```bash
cd backend
pytest tests/test_e2e.py -v
```

### What is tested

| Category | Tests |
|----------|-------|
| **Auth** | Anonymous login, token validation, unauthenticated rejection |
| **Looks** | Generate look, feed loading, pagination |
| **Votes** | Vote on look, prevent double-vote, vote nonexistent |
| **Challenges** | Daily challenge, ranking |
| **Account Deletion** | Delete account, token invalidation |

### Test Architecture

- `conftest.py` — Pytest fixtures: starts uvicorn server on port 18765, creates fresh SQLite DB
- `e2e_server.py` — Patches AI service with mocks (no real Gemini API needed)
- `test_e2e.py` — Test cases using `requests` against local server

### Requirements

```bash
pip install pytest requests
```

### CI Integration

Tests run automatically on GitHub Actions push to `main`.
