# VouDeQue Backend Tests

## Running Tests

Make sure you are inside the `backend/` directory:

```bash
cd backend
pytest tests/test_e2e.py -v
```

To run all tests:

```bash
pytest tests/ -v
```

## Test Setup

Install test dependencies:

```bash
pip install -r requirements-test.txt
```

The E2E tests spin up a real Uvicorn server on `127.0.0.1:18765` with AI services
mocked so no Gemini API key is required.

## Test Coverage

- `test_e2e.py` — End-to-end API tests covering:
  - Anonymous authentication
  - Look generation (authenticated)
  - Feed retrieval and pagination
  - Voting (including duplicate vote prevention)
  - Daily challenge
  - Account deletion
  - Unauthenticated access rejection
