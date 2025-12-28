# AGENTS.md for C:\Users\Rushabh\projects\rushg.me

<INSTRUCTIONS>
## Project Summary
- Static portfolio site served by Apache (php:8.2-apache image).
- No build step; the main entry point is the minified `index.html`.
- Legacy content includes Unity Web Player demos and PHP utilities.

## Repository Structure (Top-Level)
- `index.html`: primary page served in production (minified).
- `index_full.html`: unminified reference copy of the home page.
- `css/`, `js/`, `img/`, `fonts/`, `font-awesome/`: static assets.
- `less/`: legacy stylesheet sources (not part of a build pipeline here).
- `mail/`: PHP mail handler (uses `mail()` in PHP; see Docker for SMTP setup).
- `TreasureHunt/`: legacy PHP game/demo assets and endpoints.
- `sitemap.xml`, `404.html`, `CNAME`: SEO and domain metadata.

## Frontend / JS / CSS Guidance
- Stack: jQuery 1.11.x, Bootstrap, Font Awesome, custom CSS in `css/`.
- No bundler, no transpiler, no NPM build step.
- Keep edits minimal and avoid reformatting minified files.
- If large edits are needed, update `index_full.html` and then apply equivalent changes to `index.html`.
- Avoid adding new frameworks or build tooling unless explicitly requested.
- Prefer existing typography and theme files; this site is intentionally legacy.

## Unity / Gaming Content
- Unity Web Player page: `UnityWebPlay.html` (legacy, do not modernize unless asked).
- Demo links use query params (example: `/UnityWebPlay.html?path=demos/webplayer/AU`).
- Asset folders: `img/JPGs`, `img/JPGs-low`, `img/GIFs`, etc.
- Treat legacy gaming content as static; do not alter URLs or directory layout without a request.

## Docker (Local Build/Run)
- Dockerfile uses `php:8.2-apache`.
- Logs are configured to stdout (CustomLog/ErrorLog redirected to stdout/stderr).
- Entry point writes `/etc/msmtprc` when SMTP env vars are present.
- SMTP env vars: `SMTP_HOST`, `SMTP_PORT`, `SMTP_FROM`, `SMTP_USER`, `SMTP_PASSWORD`, `SMTP_TLS`.
- Example build/run:
  - `docker build -t rushg-portfolio .`
  - `docker run --rm -p 8080:80 rushg-portfolio`

## TrueNAS Scale Deployment (Production)
- App name: `rushg-me` (TrueNAS "iX App" custom app).
- Container image: `rushabhtechie/rushg-portfolio:latest`.
- Container port: `80`.
- Host port: `9092` and MUST be **published** (not merely exposed).
- TrueNAS config path (reference only): `/mnt/.ix-apps/app_configs/rushg-me/versions/1.2.17/`.
- Apply config changes via middlewared to keep UI in sync:
  - Read config: `midclt call app.config rushg-me`
  - Update config: `midclt call app.update rushg-me '{"values":{...}}'`
  - Redeploy: `midclt call app.redeploy rushg-me`
- Do NOT modify or restart the reverse proxy container.
- Diagnostics (read-only):
  - Verify container health: `curl -I http://192.168.1.2:9092/`
  - Compare content with `index.html` (SHA256 should match).

## Reverse Proxy (NPM) Constraints
- Nginx Proxy Manager (NPM) handles TLS and Host routing.
- Do not change, stop, or restart NPM.
- Only inspect logs if needed:
  - `proxy-host-13_access.log` for rushg.me (read-only).

## Safety / Editing Rules
- Preserve legacy HTML/JS style and file layout.
- Avoid large formatting changes to minified files.
- Keep edits ASCII unless the file already uses non-ASCII.
- Do not alter other containers or the reverse proxy.
</INSTRUCTIONS>
