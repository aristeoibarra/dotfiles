# Digital Detox System - Roadmap

Personal digital detox ecosystem for ADHD management. One brain, multiple arms.

## Vision

A centralized system to control digital distractions across all devices. Define rules once, enforce everywhere.

```
┌─────────────────────────────────────┐
│         EC2 (nextdns-blocker)       │
│         SQLite + API REST           │
│                                     │
│  • Schedules (single source)        │
│  • Blocked domains                  │
│  • Blocked apps                     │
│  • Time budgets                     │
│  • Panic mode                       │
│  • Stats/analytics                  │
└──────────────────┬──────────────────┘
                   │
   ┌───────────────┼───────────────┐
   │       │       │       │       │
   ▼       ▼       ▼       ▼       ▼
┌─────┐ ┌─────┐ ┌─────┐ ┌─────────────┐
│ Web │ │Menu │ │ App │ │   Android   │
│ App │ │ Bar │ │Block│ │   Launcher  │
│     │ │ Mac │ │ Mac │ │             │
└─────┘ └─────┘ └─────┘ └─────────────┘
```

## Core Principle

**Willpower is not enough.** The rational self sets up protections. The impulsive self tries to bypass them. The system protects the rational self's decisions through technical barriers and friction.

## Architecture

### Brain: EC2 (nextdns-blocker)

Central server running 24/7. Single source of truth.

| Component | Purpose |
|-----------|---------|
| SQLite | Database replacing JSON files |
| API REST | Interface for all clients |
| Schedules | When domains/apps are available |
| Protection | Locks, delays, panic mode |

### Arms: Clients

| Client | Platform | Function |
|--------|----------|----------|
| Web Dashboard | Browser | Configure, stats, control |
| Menu Bar | macOS | Stats, notifications, local actions |
| App Blocker | macOS | Block apps by schedule |
| Launcher | Android | Show/hide apps by schedule |

## Phases

### Phase 1: Foundation

**Goal:** Migrate from JSON to SQLite, expose API REST.

**Tasks:**
- [ ] Design SQLite schema (use #191 as guide)
- [ ] Implement database module
- [ ] Migrate config.json → SQLite
- [ ] Migrate pending.json → SQLite
- [ ] Migrate unlock_requests.json → SQLite
- [ ] Migrate audit.log → SQLite
- [ ] Create `config export/import` commands
- [ ] Implement API REST (FastAPI)
- [ ] Authentication (API key)
- [ ] Basic endpoints: `/status`, `/stats`, `/schedules`

**Related Issues:**
- #204 - Migrate from JSON to SQLite
- #191 - Config schema v2 (guide for clean structure)

---

### Phase 2: Web Dashboard

**Goal:** Control center accessible from browser.

**Features:**
- [ ] View current status (what's blocked)
- [ ] View stats/analytics
- [ ] Edit schedules
- [ ] Activate panic mode
- [ ] View time budgets
- [ ] Manage domains/apps

**Tech:** React or simple HTML + JS. Keep it minimal.

---

### Phase 3: Android Launcher

**Goal:** Control which apps are visible on Android by schedule.

**Features:**
- [ ] List apps (simple text, no icons)
- [ ] Group apps by category
- [ ] Show/hide apps based on schedule from API
- [ ] Detox mode (24h lockdown)
- [ ] Dark mode, white text, minimal UI
- [ ] Offline mode (cache schedules)
- [ ] Bypass protection (detect launcher change)

**Tech:** Kotlin, Jetpack Compose

**UI Philosophy:** Intentionally boring. The phone becomes a tool, not a toy.

```
┌─────────────────────────┐
│                         │
│  Work                   │
│  ────────────────────   │
│  Slack                  │
│  Calendar               │
│  Notes                  │
│                         │
│  Communication          │
│  ────────────────────   │
│  WhatsApp               │
│  Phone                  │
│                         │
└─────────────────────────┘
```

---

### Phase 4: macOS Menu Bar

**Goal:** Native Mac client for stats and actions.

**Features:**
- [ ] Show current status
- [ ] Show stats summary
- [ ] Native notifications
- [ ] Webhook listener for actions
- [ ] Execute local actions (flush DNS, close browsers)

**Tech:** Python + rumps (MVP) or Swift (later)

**Related Issues:**
- #203 - macOS Menu Bar App

---

### Phase 5: macOS App Blocker

**Goal:** Block Mac apps by schedule, like commercial apps (Cold Turkey, Focus, Freedom).

**Features:**
- [ ] Block apps based on schedule from API
- [ ] Graceful quit + force kill
- [ ] Integration with Menu Bar
- [ ] Bypass protection (delays, locks)

**Tech:** LaunchDaemon + Swift/Python

**Replaces:** Cold Turkey ($39), Focus ($29/yr), Freedom ($40/yr)

---

## Future Features

### Time Budgets (#181)

Allow controlled usage instead of total abstinence.

```
"30 minutes of YouTube per day"
```

- Track usage via NextDNS logs API
- Block when budget exhausted
- Reset daily/weekly

### Telegram Bot (#201)

View stats from mobile without installing anything extra.

- `/status` - What's blocked
- `/stats` - Daily summary
- Read-only, safe commands

## Protection Layers

| Layer | What it blocks | How |
|-------|----------------|-----|
| NextDNS | Network/DNS | Domain doesn't resolve |
| Android Launcher | UI | App not visible |
| macOS App Blocker | Apps | App force closed |
| Schedules | Time-based | Different rules per time |
| Panic Mode | Everything | Emergency lockdown |
| Locks/Delays | Bypass attempts | Friction before changes |

## Key Decisions

### Why SQLite over JSON?

- JSON editable = bypass potential
- SQLite forces CLI usage
- CLI has protections (locks, delays, PIN)
- Better for complex queries (stats)
- Concurrency safe

### Why custom launcher over existing apps?

- Integrated with same schedule system
- No separate configuration
- Same protections (delays, locks)
- No subscription fees
- Built for ADHD specifically

### Why boring UI?

- Less dopamine = less phone usage
- No icons = less visual attraction
- Minimal = functional, not fun
- The opposite of what apps normally do

## Current State (Temporary)

While building the full system:

| Component | Status | Location |
|-----------|--------|----------|
| Safari Blocker | Active | `/Library/LaunchDaemons/com.block.safari.plist` |
| ntfy Subscriber | Active | `~/Library/LaunchAgents/com.nextdns.refresh.plist` |
| DNS Flush Fallback | Active | `~/Library/LaunchAgents/com.flushdns.fallback.plist` |

These will be replaced by Menu Bar + App Blocker eventually.

## Success Metrics

- Zero bypass incidents per week
- Time on distracting apps < 30 min/day
- Panic mode activations trending down
- Commitment streaks increasing
