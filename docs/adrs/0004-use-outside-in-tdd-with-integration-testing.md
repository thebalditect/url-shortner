# 4. Use Outside In TDD with Integration Testing

Date: 2025-09-13

Author: Mandar Dharmadhikari

## Status

Accepted

## Context

We need to decide on a testing strategy for the URL Shortener service.
Key requirements:

* Ensure correctness and confidence during refactoring.
Support vertical slice architecture where each feature is developed end-to-end.

* Allow us to follow TDD (Test-Driven Development) practices.

* Ensure that our APIs work as expected in a realistic environment (with database, routing, request/response handling).

**Testing approaches considered**:

* **Unit testing only**: faster but may miss integration issues.

* **Integration testing first (outside-in)**: define behavior at the API boundary, then drive implementation.

* **End-to-end (E2E) testing only**: validates full flow but expensive and harder to isolate failures.

## Decision

We will use Outside-In Testing with Integration Tests as our primary approach. Each feature will start with an integration test at the API layer (using httpx or pytest-asyncio against FastAPI test client). Tests will define the contract (request/response, status codes, validation) before implementation. From the failing integration test, we will build the feature inside-out, adding domain logic, repository layers, and infrastructure as needed.

**Unit tests may be added for critical domain logic, but the main driver will be integration tests.**

## Consequences

### Positive

* **Confidence in correctness**: ensures APIs behave as expected before focusing on internals.

* Supports vertical slices: each feature is fully testable in isolation.

* **Aligns with TDD**: API contract is the starting point, preventing over-engineering.

* Catches integration bugs early (e.g., DB mappings, request validation, dependency wiring).

### Negative

* Slower test runs compared to unit-only strategies.

* May require managing test database state carefully (fixtures, migrations, transaction rollbacks).

* Overhead in setting up containerized test environments for full realism.
