# Nexlayer — whoogle-search

<!-- nexlayer:meta version=1 analyzed=2026-06-30T23:37:49Z repo=https://github.com/armondhonore/whoogle-search branch=nexlayer -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
Whoogle Search is a self-hosted Google search proxy that removes ads, JavaScript, and tracking, providing a privacy-focused search interface.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Python | language | 3.12 | Dockerfile, pyproject.toml |
| Flask | framework | 3.1.3 | requirements.txt |
| Waitress | infra | 3.0.2 | requirements.txt |
| Tor | infra | latest | Dockerfile |
| Alpine Linux | infra | 3.22 | Dockerfile |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- app/ — Core Flask application logic and search handlers
- docs/ — Project documentation
- test/ — Test suites
- run — Entrypoint script for starting the service
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- Google Search (via scraping/CSE)
- Tor Network (for proxying requests)
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Python >= 3.12
- pip

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
WHOOGLE_PORT=5000
WHOOGLE_USER=admin
WHOOGLE_PASS=password
```

### Steps

1. `pip install -r requirements.txt` — Install Python dependencies
2. `python run` — Start the Whoogle server

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### nexlayer.yaml

```yaml
application:
  name: whoogle
  pods:
  - name: app
    image: mirror.gcr.io/benbusby/whoogle-search:latest
    path: /
    servicePorts:
    - 5000
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| whoogle | mirror.gcr.io/library/python:3.12-alpine3.22 | 5000 | web |
| tor | mirror.gcr.io/library/alpine:3.22 | 9050 | worker |

### Deployment notes

- The Dockerfile installs Tor internally, but according to Nexlayer Rule 1, Tor is separated into its own pod.
- The whoogle pod communicates with the tor pod via tor.pod:9050.
- All images are mirrored via gcr.io to comply with Nexlayer image naming constraints.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-30T23:39:17Z  
**Live URL:** https://relaxed-weasel-whoogle.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: whoogle
  pods:
  - name: app
    image: mirror.gcr.io/benbusby/whoogle-search:latest
    path: /
    servicePorts:
    - 5000
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-30T23:37:49Z | analyzed | initial repo analysis |
| 2026-06-30T23:39:17Z | success | deployed https://relaxed-weasel-whoogle.cloud.nexlayer.ai |
<!-- nexlayer:end -->
