# Brave Browser Configuration

Minimal, privacy-focused policy profile for [Brave Browser](https://brave.com/) on macOS.

## What it does

Aplica políticas de Chromium/Brave vía un Configuration Profile (`.mobileconfig`):

- **Sin modo privado** (`IncognitoModeAvailability=1`) — capa extra de foco ADHD
- **Sin Tor** (`TorDisabled`) — las ventanas Tor evaden NextDNS, el router y `/etc/hosts`
- **DNS anclado al sistema** — ver abajo
- **Cero telemetría** — `MetricsReportingEnabled`, `BraveStatsPingEnabled`, `UserFeedbackAllowed` off
- **Sin bloat** — Brave AI Chat, Rewards, Wallet, VPN deshabilitados
- **Password manager off** — usa Bitwarden
- **Sin sync ni signin** — `SyncDisabled`, `BrowserSignin=0`
- **Brave Search** como motor por defecto
- **UI limpia** — bookmark bar oculta, sin promotional tabs

## DNS

Secure DNS **no es por perfil**: Chromium lo guarda en `Local State`, global al navegador.
Cambiarlo en un perfil lo cambia en todos.

Dos políticas lo anclan al resolver del sistema, que apunta a NextDNS vía
`/Library/Managed Preferences/com.apple.dnsSettings.managed.plist`:

| Política | Valor | Por qué |
|---|---|---|
| `DnsOverHttpsMode` | `off` | Brave no hace DoH propio; el toggle de la UI queda bloqueado |
| `BuiltInDnsClientEnabled` | `false` | Usa `getaddrinfo()`, así aplican el perfil DoH del sistema y `/etc/hosts` |

**Las dos son necesarias.** Con `off` solo, el cliente DNS interno de Chromium sigue
hablando directo al nameserver del router y se salta el perfil DoH del sistema.

Verificar: `jq '.dns_over_https' "Local State"` no debe existir, y `brave://settings/security`
debe mostrar el selector en gris con el ícono de "managed".

## New Tab page (`newtab-vimium/`)

**`NewTabPageLocation` no funciona en Brave.** La policy se aplica (`forced=true`) y Brave la
ignora para `⌘T`: sirve su propia NTP. Verificado el 2026-07-15 con `--v=1` — al abrir pestañas
no hay ninguna request a la URL de la policy; las únicas salen del arranque, y esas vienen de
`RestoreOnStartupURLs`. Probado con `brave.new_tab_page.shows_options` en 0, 1 y 2: sin diferencia.
Coincide con los bugs de Brave [#39885](https://github.com/brave/brave-browser/issues/39885)
(Dashboard == Homepage) y el hilo de "New Tab Page shows Homepage does not work".

El único mecanismo que sí funciona es `chrome_url_overrides.newtab` en una extensión.
`newtab-vimium/` es esa extensión: 3 archivos, cero permisos.

**El JS va en archivo aparte a propósito.** La CSP de MV3 es `script-src 'self'` y bloquea
`<script>` inline — si se mete el `location.replace` dentro del HTML, la página queda en
blanco y parece que la extensión no sirve.

Instalar: `brave://extensions` → Developer mode → Load unpacked → `~/dotfiles/brave/newtab-vimium`

Trade-offs conocidos:
- **El foco.** `⌘T` normalmente deja el cursor en la omnibox; con una NTP de extensión que
  redirige, el foco puede irse a la página. Si pasa, `⌘L` regresa a la barra.
- Es unpacked → se apaga con un toggle y `ExtensionInstallForcelist` no funciona en este Brave
  (ver sección de DNS). Si algún día `ndb URL Blocker` se publica unlisted en el Web Store,
  la forma limpia es mover este `chrome_url_overrides` al manifest de `ndb` y borrar esta
  extensión — una en vez de dos.

## Immutable flags (schg)

Los managed prefs van sellados con `schg` para que cambiarlos requiera un paso consciente:

```bash
sudo chflags noschg "/Library/Managed Preferences/com.brave.Browser.plist"   # editar
sudo chflags schg   "/Library/Managed Preferences/com.brave.Browser.plist"   # re-sellar
```

**Sellar los dos niveles.** CFPreferences le da precedencia a
`/Library/Managed Preferences/<user>/` sobre `/Library/Managed Preferences/`, así que
sellar solo el de máquina no sirve de nada: el de usuario lo sobrescribe. Las llaves que
el de usuario no define sí se heredan del de máquina (merge por llave) — de ahí que
`ExtensionInstallForcelist` viva solo en el de máquina y siga aplicando.

## Install

macOS Sequoia (15+) ya no permite instalar perfiles vía CLI (`profiles install` fue removido). Hay que hacerlo desde System Settings:

```bash
# Cierra Brave
osascript -e 'quit app "Brave Browser"'

# Abre el perfil (macOS lo dejará pendiente de aprobación)
open ~/dotfiles/brave/brave-policies.mobileconfig
```

Luego:
1. **System Settings → General → Device Management → Profiles** (o busca "Profiles")
2. Click en **"Brave Browser - Dotfiles Policies"** → **Install** → password
3. Abre Brave y entra a `brave://policy` — deberías ver todas las políticas como **Platform / Mandatory**

Si alguna policy aparece como **Unknown** o **Error**, esa versión de Brave no la reconoce: quítala del `.mobileconfig` y reinstala.

### Extensiones (fuera del perfil)

El perfil no instala extensiones. Después de instalar el perfil:

1. **New Tab override** — `brave://extensions` → Developer mode (on) → Load unpacked → `~/dotfiles/brave/newtab-vimium` (ver sección **New Tab page**)
2. **Vimium** — instálala desde el Chrome Web Store, luego `brave://extensions` → Vimium → Details → Extension options → importa `~/dotfiles/brave/vimium-options.json`

## Uninstall

System Settings → General → Device Management → Profiles → seleccionar el perfil → **−** (remove).

## Edit

`profiles install` ya no existe en Sequoia. Si modificas `brave-policies.mobileconfig`: quita el perfil actual (System Settings → Profiles → **−**) y reinstálalo con los pasos de **Install**. Si los managed prefs están sellados con `schg`, primero `chflags noschg` (ver **Immutable flags**).

## Notas

- Las optimizaciones de red (HTTP/3, prefetch, race-cache) que tenía Zen vía `user.js` no necesitan config en Brave — Chromium las hace por defecto.
- Brave Shields ya viene en modo strict por defecto; no hay policy que cambiarlo.
- Si una política no se aplica, revisa `brave://policy` para ver si Brave la reconoce — algunas requieren versión reciente.
