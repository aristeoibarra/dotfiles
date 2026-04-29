# Brave Browser Configuration

Minimal, privacy-focused policy profile for [Brave Browser](https://brave.com/) on macOS.

## What it does

Aplica políticas de Chromium/Brave vía un Configuration Profile (`.mobileconfig`):

- **Sin modo privado** (`IncognitoModeAvailability=1`) — capa extra de foco ADHD
- **Cero telemetría** — `MetricsReportingEnabled`, `BraveStatsPingEnabled`, `UserFeedbackAllowed` off
- **Sin bloat** — Brave AI Chat, Rewards, Wallet, VPN deshabilitados
- **Password manager off** — usa Bitwarden
- **Sin sync ni signin** — `SyncDisabled`, `BrowserSignin=0`
- **Brave Search** como motor por defecto
- **UI limpia** — bookmark bar oculta, sin promotional tabs

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

## Uninstall

System Settings → General → Device Management → Profiles → seleccionar el perfil → **−** (remove).

## Edit

Si modificas `brave-policies.mobileconfig`, reinstala con `profiles install` (sobrescribe el existente).

## Notas

- Las optimizaciones de red (HTTP/3, prefetch, race-cache) que tenía Zen vía `user.js` no necesitan config en Brave — Chromium las hace por defecto.
- Brave Shields ya viene en modo strict por defecto; no hay policy que cambiarlo.
- Si una política no se aplica, revisa `brave://policy` para ver si Brave la reconoce — algunas requieren versión reciente.
