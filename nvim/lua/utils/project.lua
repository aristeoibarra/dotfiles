-- Auto-detect project type (Frontend vs Backend) with caching
local M = {}

-- Cache detection results to avoid repeated file checks
local detection_cache = {}
local cache_timestamp = {}
local CACHE_TTL = 300  -- 5 minutes

-- ============================================================================
-- DETECTION
-- ============================================================================

function M.detect_project_type(force_refresh)
  local cwd = vim.fn.getcwd()
  local now = vim.uv.now()

  -- Check cache validity
  if not force_refresh and detection_cache[cwd] and cache_timestamp[cwd] then
    if (now - cache_timestamp[cwd]) < CACHE_TTL * 1000 then
      return detection_cache[cwd]
    end
  end

  -- Frontend indicators (high priority)
  local next_config = vim.fn.glob(cwd .. "/next.config.*")
  if next_config ~= "" then
    detection_cache[cwd] = "frontend"
    cache_timestamp[cwd] = now
    return "frontend"
  end

  -- Backend indicators (high priority - before frontend fallback)
  local prisma_schema = vim.fn.glob(cwd .. "/prisma/schema.prisma")
  if prisma_schema ~= "" then
    detection_cache[cwd] = "backend"
    cache_timestamp[cwd] = now
    return "backend"
  end

  local nest_cli = vim.fn.glob(cwd .. "/nest-cli.json")
  if nest_cli ~= "" then
    detection_cache[cwd] = "backend"
    cache_timestamp[cwd] = now
    return "backend"
  end

  -- NestJS main file
  local nest_main = vim.fn.glob(cwd .. "/src/main.ts")
  if nest_main ~= "" then
    detection_cache[cwd] = "backend"
    cache_timestamp[cwd] = now
    return "backend"
  end

  -- Frontend medium priority (after backend indicators)
  local app_dir = vim.fn.glob(cwd .. "/app")
  if app_dir ~= "" and app_dir ~= "/" then  -- Avoid false positives on system /app
    detection_cache[cwd] = "frontend"
    cache_timestamp[cwd] = now
    return "frontend"
  end

  local vite_config = vim.fn.glob(cwd .. "/vite.config.*")
  if vite_config ~= "" then
    detection_cache[cwd] = "frontend"
    cache_timestamp[cwd] = now
    return "frontend"
  end

  -- Default to unknown
  detection_cache[cwd] = "unknown"
  cache_timestamp[cwd] = now
  return "unknown"
end

-- ============================================================================
-- CONVENIENCE FUNCTIONS
-- ============================================================================

function M.is_frontend()
  return M.detect_project_type() == "frontend"
end

function M.is_backend()
  return M.detect_project_type() == "backend"
end

function M.is_unknown()
  return M.detect_project_type() == "unknown"
end

-- ============================================================================
-- DEBUGGING
-- ============================================================================

function M.get_detection_info()
  local cwd = vim.fn.getcwd()
  local project_type = M.detect_project_type()

  local info = {
    cwd = cwd,
    project_type = project_type,
    cached = detection_cache[cwd] ~= nil,
    indicators = {},
  }

  -- Check specific indicators
  if vim.fn.glob(cwd .. "/next.config.*") ~= "" then
    table.insert(info.indicators, "✓ next.config found")
  end
  if vim.fn.glob(cwd .. "/nest-cli.json") ~= "" then
    table.insert(info.indicators, "✓ nest-cli.json found")
  end
  if vim.fn.glob(cwd .. "/prisma/schema.prisma") ~= "" then
    table.insert(info.indicators, "✓ prisma/schema.prisma found")
  end
  if vim.fn.glob(cwd .. "/src/main.ts") ~= "" then
    table.insert(info.indicators, "✓ src/main.ts found")
  end
  if vim.fn.glob(cwd .. "/app") ~= "" then
    table.insert(info.indicators, "✓ app/ directory found")
  end
  if vim.fn.glob(cwd .. "/vite.config.*") ~= "" then
    table.insert(info.indicators, "✓ vite.config found")
  end
  if vim.fn.glob(cwd .. "/package.json") ~= "" then
    table.insert(info.indicators, "✓ package.json found")
  end

  return info
end

-- Create user command for debugging
vim.api.nvim_create_user_command("ProjectInfo", function()
  local info = M.get_detection_info()

  local message = string.format(
    "\n📁 Project Type: %s\n📂 Directory: %s\n🔍 Indicators:\n   %s\n",
    info.project_type:upper(),
    info.cwd,
    table.concat(info.indicators, "\n   ")
  )

  vim.notify(message, vim.log.levels.INFO)
end, {})

return M
