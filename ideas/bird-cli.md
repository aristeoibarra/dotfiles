# Bird CLI — X/Twitter desde la terminal

CLI open source para leer y interactuar con X/Twitter via GraphQL + cookies del browser.
Sin API keys, sin cuenta de developer, sin costo.

- **Repo**: [steipete/bird](https://github.com/steipete/bird)
- **Web**: [bird.fast](https://bird.fast/)
- **Autor**: Peter Steinberger (@steipete)
- **Licencia**: MIT
- **Version**: 0.8.0
- **Node**: >= 22

## Instalacion

```bash
# macOS (recomendado)
brew install steipete/tap/bird

# npm/pnpm/bun
npm install -g @steipete/bird

# sin instalar
bunx @steipete/bird whoami
```

## Autenticacion

Usa cookies de tu browser (Safari, Chrome, Firefox). No pide password ni API keys.

Orden de resolucion:
1. Flags CLI: `--auth-token`, `--ct0`
2. Variables de entorno: `AUTH_TOKEN`, `CT0`
3. Cookies del browser via `@steipete/sweet-cookie`

```bash
# verificar sesion
bird whoami

# diagnostico de credenciales
bird check
```

### Config opcional

`~/.config/bird/config.json5`:

```json5
{
  cookieSource: ["safari", "chrome"],
  timeoutMs: 20000,
  quoteDepth: 1
}
```

## Comandos — Lectura

### Home timeline

```bash
bird home                    # For You
bird home --following        # solo gente que sigues
bird home -n 30 --json       # JSON para pipes
```

### News y trending

```bash
bird news -n 10              # todas las tabs
bird news --ai-only -n 10   # solo curadas por AI
bird news --news-only -n 10  # tab News
bird news --sports -n 5      # tab Sports
bird trending                # alias de news

# con tweets relacionados
bird news --with-tweets --tweets-per-item 3 -n 10

# tabs especificas combinadas
bird news --sports --entertainment -n 20
```

Tabs disponibles: `--for-you`, `--news-only`, `--sports`, `--entertainment`, `--trending-only`

### Busqueda

```bash
bird search "LLM OR Claude" -n 20
bird search "from:karpathy" -n 10
bird search "AI lang:es" -n 15 --json
bird search "query" --all --max-pages 3
```

### Leer tweets e hilos

```bash
bird read <url-or-id>                    # tweet individual
bird thread <url-or-id>                  # hilo completo
bird replies <url-or-id>                 # respuestas
bird replies <id> --max-pages 3 --json   # paginado
```

### Perfil de usuario

```bash
bird user-tweets @karpathy -n 20
bird user-tweets @steipete -n 50 --json
bird about @usuario                      # info de cuenta
```

### Bookmarks

```bash
bird bookmarks -n 10
bird bookmarks --folder-id 123456789     # carpeta especifica
bird bookmarks --all --json              # todos en JSON
bird bookmarks --include-parent          # con tweet padre
bird bookmarks --sort-chronological      # orden cronologico

# flags de expansion de hilos
#   --expand-root-only    expandir solo si el bookmark es root
#   --author-chain        solo cadena de self-replies del autor
#   --author-only         todos los tweets del autor en el hilo
#   --full-chain-only     cadena completa de replies (todos los autores)
#   --include-parent      incluir tweet padre directo
#   --thread-meta         metadata del hilo
```

### Likes

```bash
bird likes -n 10
bird likes --all --max-pages 2 --json
```

### Listas

```bash
bird lists                               # tus listas
bird lists --member-of                   # listas donde eres miembro
bird list-timeline <id-or-url> -n 20
bird list-timeline <id> --all --json
```

### Seguidores

```bash
bird following -n 20
bird followers -n 20
bird following --user 12345678 -n 10     # de otro usuario (por ID)
```

### Menciones

```bash
bird mentions -n 5
bird mentions --user @steipete -n 5
```

## Comandos — Escritura

> **Advertencia**: postear tiene riesgo de ban. Los devs reportan que lectura tiene
> 99.8% fiabilidad sin warnings, pero escritura ha causado suspensiones.

```bash
bird tweet "texto del tweet"
bird reply <id-or-url> "respuesta"

# con media (hasta 4 imagenes o 1 video)
bird tweet "mira esto" --media img.png --alt "descripcion"
```

## Comandos — Gestion

```bash
bird unbookmark <id-or-url>              # quitar bookmark
bird unbookmark <id1> <id2> <id3>        # multiples
bird query-ids --fresh                   # refrescar cache de query IDs
```

## Output

| Flag | Efecto |
|------|--------|
| `--json` | objetos JSON crudos |
| `--json-full` | incluye respuesta raw de la API |
| `--plain` | sin emoji, sin color (para scripts) |
| `--no-emoji` | solo quitar emojis |
| `--no-color` | sin colores ANSI (o `NO_COLOR=1`) |

### Schema JSON de tweets

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | string | Tweet ID |
| `text` | string | Texto completo (incluye Notes/Articles) |
| `author` | object | `{ username, name }` |
| `authorId` | string? | User ID del autor |
| `createdAt` | string | Timestamp |
| `replyCount` | number | Replies |
| `retweetCount` | number | Retweets |
| `likeCount` | number | Likes |
| `conversationId` | string | ID del hilo |
| `inReplyToStatusId` | string? | Tweet padre (si es reply) |
| `quotedTweet` | object? | Quote tweet embebido |

### Schema JSON de news/trending

| Campo | Tipo | Descripcion |
|-------|------|-------------|
| `id` | string | ID unico |
| `headline` | string | Titulo |
| `category` | string? | Categoria |
| `timeAgo` | string? | Tiempo relativo |
| `postCount` | number? | Numero de posts |
| `description` | string? | Descripcion |
| `url` | string? | URL del trend |
| `tweets` | array? | Tweets relacionados (con `--with-tweets`) |

## Opciones globales

```
--auth-token <token>         cookie auth_token manual
--ct0 <token>                cookie ct0 manual
--cookie-source <browser>    safari|chrome|firefox (repetible, orden importa)
--chrome-profile <name>      perfil de Chrome (Default, Profile 2...)
--firefox-profile <name>     perfil de Firefox
--timeout <ms>               timeout de requests
--quote-depth <n>            profundidad de quote tweets (default: 1)
```

## Mecanismo de Query IDs

X rota los query IDs de GraphQL frecuentemente. Bird maneja esto automaticamente:

- Cache en `~/.config/bird/query-ids-cache.json` (TTL: 24h)
- Auto-recovery en error 404: refresca IDs y reintenta
- Fallback IDs para `TweetDetail` y `SearchTimeline`
- Refrescar manual: `bird query-ids --fresh`
- Override path: `BIRD_QUERY_IDS_CACHE=/path/to/file.json`

## Dependencias

Solo 4 (muy ligero, sin headless browser):

- `commander` — framework CLI
- `kleur` — colores terminal
- `json5` — parsing de config
- `@steipete/sweet-cookie` — extraccion de cookies del browser

## Riesgos

- Usa la API GraphQL **privada** de X — puede romperse sin aviso
- Escritura (tweet/reply) puede causar ban o bloqueo temporal
- Lectura es segura: 99.8% fiabilidad, cero warnings reportados
- Si X detecta patron de automatizacion, puede invalidar la sesion
- Rate limiting (HTTP 429) posible en uso intensivo

## Ejemplos de uso diario

```bash
# manana: que hay de nuevo en tech
bird news --ai-only --news-only -n 15

# revisar timeline rapido
bird home --following -n 30

# buscar tema especifico
bird search "Rust OR Go performance" -n 20

# leer hilo interesante
bird thread https://x.com/user/status/123456

# exportar bookmarks tech
bird bookmarks --all --json | jq '.tweets[] | {text, author}'

# limpiar bookmarks viejos
bird unbookmark <id1> <id2>
```

## Exit codes

- `0` — exito
- `1` — error de runtime (red, auth, etc)
- `2` — uso invalido / validacion

## Skill para Claude Code

El skill mas popular: **liewcf/agent-skills@bird** (37 installs)

```bash
npx skills add liewcf/agent-skills@bird -g -y
```

- Le da a Claude Code acceso directo a bird para leer tweets, buscar, trending, bookmarks
- Requiere bird instalado (`brew install steipete/tap/bird` o `npm install -g @steipete/bird`)
- Usa cookie auth del browser (misma config que el CLI)
- Output `--json` para que Claude procese los datos
- Security audits: Gen Agent Trust Hub (Pass), Socket (Pass)
- Recomendacion del skill: solo lectura, postear puede causar bloqueos

### Comandos que el skill expone a Claude

```bash
# leer tweet o hilo
bird read <url-or-id> --json
bird thread <url-or-id> --json

# buscar
bird search "query" -n 10 --json
bird search "from:username" -n 20 --json
bird search "query since:2024-01-01" -n 50 --json

# trending y noticias
bird news --ai-only -n 10 --json
bird trending -n 10 --json

# usuario
bird user-tweets @username -n 20 --json
bird mentions --user @username -n 10 --json

# bookmarks
bird bookmarks -n 20 --json
bird unbookmark <id-or-url>
```
