# Deployment Report — Checkpoint 5

## Student

| Field | Value |
|---|---|
| Name | Nguyen Huu Thanh |
| Mã học viên | 2A202602813 |
| Repository | https://github.com/nhthanh1106/K4-L3B-DAY12-NguyenHuuThanh-2A202602813-CloudServicesAndDeployment |

## Service

| Field | Value |
|---|---|
| Public URL | Pending cloud deployment approval |
| Platform | Render Blueprint |
| Deployment date | Pending deployment |

The Render configuration is prepared in `render.yaml`. The service has not yet
been created or published. Replace the pending values above and add real command
outputs after the service is deployed.

The current Blueprint uses Render's free Key Value plan for a demo. Its data is
in-memory and can be lost when the service restarts, so chat history is not
durable. Choose a paid persistent plan if the checkpoint requires data to
survive restarts; that may incur charges.

## Environment variables

These names are planned for the Render web service. Secret values must be entered
in the Render dashboard and must never be committed here.

| Variable | Source |
|---|---|
| `PORT` | Assigned by Render |
| `AGENT_API_KEY` | Render dashboard secret (`sync: false`) |
| `REDIS_URL` | Internal connection string from the Render Key Value service |
| `RATE_LIMIT_PER_MINUTE` | Render Blueprint default: `10` |
| `MONTHLY_BUDGET_USD` | Render Blueprint default: `10.0` |
| `LOG_LEVEL` | Render Blueprint default: `INFO` |

## CI/CD deployment settings

After creating the Render service, add these GitHub Actions settings:

| GitHub setting | Value |
|---|---|
| Repository secret `RENDER_DEPLOY_HOOK_URL` | Render service deploy hook URL |
| Repository variable `PUBLIC_URL` | Public HTTPS service URL |

The workflow only triggers a deployment on pushes to `main`, after the test and
Docker build jobs succeed. Pull requests run CI but do not deploy.

## Verification

Run these commands after publishing the service; replace `<PUBLIC_URL>` with the
service URL and provide the deployed API key only in your local shell:

```bash
curl -i <PUBLIC_URL>/health
curl -i <PUBLIC_URL>/ready
curl -i -X POST <PUBLIC_URL>/ask \
  -H "Content-Type: application/json" \
  -d '{"question":"Hello"}'
curl -i -X POST <PUBLIC_URL>/ask \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $AGENT_API_KEY" \
  -H "X-User-Id: sv-test" \
  -d '{"question":"Deploy là gì?"}'
```

Expected responses: `/health` returns 200, `/ready` returns 200 when Redis is
reachable, `/ask` without a key returns 401, and `/ask` with the correct key
returns 200 with a mock answer.

## Screenshots

After deployment, save these screenshots in `screenshots/`:

- `screenshots/dashboard.png` — Render service dashboard.
- `screenshots/health.png` — successful public `/health` response.

No public deployment output or screenshots are recorded yet because the Render
service has not been created.
