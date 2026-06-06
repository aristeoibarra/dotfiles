export default async ({ $, directory }) => {
  const THRESHOLD_SEC = 10
  const STATE_FILE_PREFIX = "/tmp/opencode-notify-"

  return {
    name: "notifications",
    event: async ({ event }) => {
      if (event.type !== "session.idle" && event.type !== "session.error") return

      const sessionId = event.sessionId || "default"
      const stateFile = `${STATE_FILE_PREFIX}${sessionId}`

      const now = Math.floor(Date.now() / 1000)
      let elapsed = THRESHOLD_SEC

      try {
        const lastTs = await $`cat ${stateFile} 2>/dev/null`.text()
        elapsed = now - parseInt(lastTs.trim(), 10)
      } catch {}

      await $`echo ${now} > ${stateFile}`

      if (elapsed < THRESHOLD_SEC) return

      const isError = event.type === "session.error"
      const projectName = directory ? directory.split("/").pop() : "Project"

      let duration = ""
      if (elapsed >= 3600) {
        duration = `${Math.floor(elapsed / 3600)}h${Math.floor((elapsed % 3600) / 60)}m`
      } else if (elapsed >= 60) {
        duration = `${Math.floor(elapsed / 60)}m`
      } else {
        duration = `${elapsed}s`
      }

      const title = isError ? "OpenCode · Error" : "OpenCode"
      const body = isError
        ? `${projectName} — ${duration} · Error`
        : `${projectName} — ${duration}`

      await $`afplay /System/Library/Sounds/Glass.aiff &`
      await $`osascript -e 'display notification "${body}" with title "${title}"'`
    },
  }
}
