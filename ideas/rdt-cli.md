# rdt-cli — Reddit desde la terminal

CLI open source para leer Reddit via API reverse-engineered + cookies del browser.
Sin API keys, sin cuenta de developer, sin costo.

- **Repo**: [jackwener/rdt-cli](https://github.com/jackwener/rdt-cli)
- **Autor**: Jack Wener (@jackwener)
- **Licencia**: Apache-2.0
- **Python**: >= 3.10

## Instalacion

```bash
# recomendado
uv tool install rdt-cli
uv tool upgrade rdt-cli

# alternativa
pipx install rdt-cli

# desde source
git clone git@github.com:jackwener/rdt-cli.git
cd rdt-cli && uv sync
```

## Autenticacion

Extrae cookies del browser (Chrome, Firefox, Edge, Brave). Se guardan en `~/.config/rdt-cli/credential.json` con TTL de 7 dias y auto-refresh.

```bash
rdt login                # extraer cookies del browser
rdt status               # verificar sesion
rdt whoami               # perfil (karma, edad de cuenta)
rdt logout               # limpiar credenciales
```

## Comandos — Lectura

### Feeds

```bash
rdt feed                          # home feed
rdt feed --subs-only              # solo suscripciones (sin algoritmo)
rdt feed --subs-only -n 5         # limitar posts
rdt popular                       # posts populares
rdt all                           # /r/all
```

### Subreddits

```bash
rdt sub programming               # browse un sub
rdt sub rust -s top -t week        # sort + filtro de tiempo
rdt sub-info programming           # metadata del sub
```

Sorting: `hot`, `new`, `top`, `rising`, `controversial`
Tiempo: `hour`, `day`, `week`, `month`, `year`, `all`

### Leer posts

```bash
rdt read <post_id>                 # leer post por ID
rdt read <post_id> --expand-more   # expandir "more comments"
rdt show 3                         # leer post #3 del ultimo listado
rdt show 3 -s top                  # ordenar comentarios
rdt open 3                         # abrir en browser
```

Sort de comentarios: `top`, `best`, `new`, `controversial`, `old`, `qa`

### Busqueda

```bash
rdt search "rust async"                     # busqueda global
rdt search "tokio" -r rust                  # en un sub especifico
rdt search "performance" -s top -t year     # con sort y tiempo
rdt search "query" -o results.json          # exportar resultados
```

### Usuarios

```bash
rdt user spez                      # perfil
rdt user-posts spez                # submissions
rdt user-comments spez             # historial de comentarios
rdt saved                          # tus posts guardados
rdt upvoted                        # tus posts upvoteados
```

### Export

```bash
rdt export "query" -n 100 -o file.csv      # bulk export
rdt sub rust --json -o rust-posts.json      # cualquier listado a archivo
```

## Comandos — Interaccion (requiere login)

```bash
rdt upvote 3                       # upvote por short-index
rdt upvote 3 --down                # downvote
rdt upvote 3 --undo                # quitar voto
rdt save 3                         # guardar post
rdt save 3 --undo                  # quitar guardado
rdt subscribe programming          # suscribirse
rdt subscribe programming --undo   # desuscribirse
rdt comment 3 "texto"              # comentar (rate-limit 1.5-4s)
```

## Short-index

Despues de cualquier listado (`feed`, `sub`, `search`, `popular`), los resultados se cachean en `~/.config/rdt-cli/index_cache.json`:

```bash
rdt sub rust                       # lista posts, asigna indices
rdt show 1                         # leer post #1
rdt open 5                         # abrir #5 en browser
rdt upvote 2                       # upvote al #2
```

## Output

| Flag | Efecto |
|------|--------|
| `--json` | JSON con envelope |
| `--yaml` | YAML (default en non-TTY) |
| `--compact` | output eficiente para agents/LLMs |
| `--full-text` | cuerpo completo de posts |
| `-o FILE` | escribir a archivo |

Envelope:
```yaml
ok: true
schema_version: "1"
data: { ... }
```

Variable de entorno: `OUTPUT=auto|yaml|json|rich`

## Anti-deteccion

- Fingerprint Chrome 133 consistente (User-Agent, sec-ch-ua)
- Jitter gaussiano entre requests (~1s mean, sigma=0.3)
- ~5% de requests incluyen pause de 2-5s (simula lectura)
- Exponential backoff en HTTP 429/5xx (3 retries)
- Merge de Set-Cookie headers en sesion

## Integracion con AI agents

```bash
# como skill de Claude Code
npx skills add jackwener/rdt-cli

# manual: clonar a .agents/skills/rdt-cli/
```

Incluye `SKILL.md` para instrucciones de agente.

## Dependencias

- `click` — framework CLI
- `playwright` — browser automation (para cookies)
- `httpx` — HTTP client

## Troubleshooting

| Problema | Solucion |
|----------|----------|
| No cookies found | Login en reddit.com en browser, luego `rdt login` |
| Database locked | Cerrar browser, reintentar login |
| Session expired | `rdt logout && rdt login` |
| Rate limited | Esperar; backoff automatico reintenta |
| Requests lentos | Delay gaussiano (~1s) es intencional |

## Riesgos

- Usa API reverse-engineered, puede romperse si Reddit cambia endpoints
- Lectura casual es segura — bans son por spam, bots de posting o scraping masivo
- Reddit API free oficial permite 100 queries/min; rdt-cli respeta rate limits automaticamente
- Reddit envia cease-and-desist antes de escalar a ban

## Ejemplos de uso diario

```bash
# que hay nuevo en tech
rdt sub programming -s hot -n 15
rdt sub rust -s top -t day

# buscar tema especifico
rdt search "async runtime" -r rust -s top

# leer post interesante del listado anterior
rdt show 3 --expand-more

# feed personalizado sin algoritmo
rdt feed --subs-only -n 20

# exportar para leer despues
rdt sub machinelearning -s top -t week --json -o ml-weekly.json
```

## Herramientas relacionadas del mismo autor

Jack Wener mantiene CLIs similares para: Xiaohongshu, Twitter/X, Bilibili, Discord, Telegram.

## Skill para Claude Code

El skill mas popular: **resciencelab/opc-skills@reddit** (1.4K installs, 612 stars)

```bash
npx skills add resciencelab/opc-skills@reddit -g -y
```

- **No requiere API key ni autenticacion** — usa la API publica JSON de Reddit (`.json` al final de URLs)
- No requiere rdt-cli instalado (usa scripts Python propios)
- Rate limit: 100 requests/min
- Security audits: Gen Agent Trust Hub (Pass), Socket (Pass)
- Compatible con: claude-code, cursor, codex, gemini-cli, github-copilot, amp

### Comandos que el skill expone a Claude

```bash
# posts de un subreddit
python3 scripts/get_posts.py python --limit 20
python3 scripts/get_posts.py rust --sort new --limit 20
python3 scripts/get_posts.py programming --sort top --time week

# busqueda global o en un sub
python3 scripts/search_posts.py "AI agent" --limit 20
python3 scripts/search_posts.py "MCP server" --subreddit ClaudeAI --limit 10
python3 scripts/search_posts.py "async python" --sort top --time year

# info de subreddit
python3 scripts/get_subreddit.py python
python3 scripts/get_subreddit.py ClaudeAI

# post con comentarios
python3 scripts/get_post.py abc123
python3 scripts/get_post.py abc123 --comments 50

# perfil de usuario
python3 scripts/get_user.py spez
python3 scripts/get_user.py spez --posts 10
```

### Opciones de sort

| Sort | Descripcion | Filtro de tiempo |
|------|-------------|------------------|
| `hot` | Trending (default) | — |
| `new` | Mas recientes | — |
| `top` | Mas votados | hour, day, week, month, year, all |
| `rising` | Ganando traccion | — |
| `controversial` | Votos mixtos | hour, day, week, month, year, all |
