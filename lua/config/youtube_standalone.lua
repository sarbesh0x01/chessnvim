-- ~/.config/nvim/lua/config/youtube_perfect.lua
-- Perfect YouTube player with precise positioning

local M = {}

-- Function to close any existing mpv instances
function M.close()
  os.execute("pkill -f mpv")
  vim.notify("YouTube player closed", vim.log.levels.INFO)
end

-- Function to get screen dimensions for proper positioning
local function get_screen_dimensions()
  -- Try to get actual screen size using xrandr
  local handle = io.popen("xrandr 2>/dev/null | grep ' connected' | grep -o '[0-9]\\+x[0-9]\\+' | head -n1")
  if not handle then return {width = 1920, height = 1080} end
  
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  
  local width, height = result:match("(%d+)x(%d+)")
  if not width or not height then return {width = 1920, height = 1080} end
  
  return {width = tonumber(width), height = tonumber(height)}
end

-- Function to play a YouTube video with perfect positioning
function M.play(url_or_search)
  -- Close any existing instances first
  M.close()
  
  -- Input validation
  if not url_or_search or url_or_search == "" then
    vim.notify("Please provide a YouTube URL or search term", vim.log.levels.WARN)
    return
  end
  
  -- Get screen dimensions for precise positioning
  local screen = get_screen_dimensions()
  
  -- Calculate exact window size (25% of screen) and position (bottom-right corner)
  local width = math.floor(screen.width * 0.25)
  local height = math.floor(screen.height * 0.25)
  local x_pos = screen.width - width
  local y_pos = screen.height - height
  
  -- Determine if it's a URL or search term
  local is_url = string.match(url_or_search, "^https?://") ~= nil
  
  -- Use yt-dlp if available
  local use_ytdlp = vim.fn.executable('yt-dlp') == 1
  local ytdl_opt = use_ytdlp and "--script-opts=ytdl_hook-ytdl_path=yt-dlp" or ""
  
  -- Build command with exact positioning and size
  local cmd
  if is_url then
    cmd = string.format(
      "mpv %s --vo=gpu --hwdec=no --ytdl-format='bestvideo[height<=720]+bestaudio/best[height<=720]' " ..
      "--geometry=%dx%d+%d+%d --no-border --ontop --force-window=yes --window-scale=0.25 " ..
      "--title='ChessNVIM YouTube' --no-terminal " ..
      "'%s' > /dev/null 2>&1 &",
      ytdl_opt, width, height, x_pos, y_pos, url_or_search
    )
  else
    -- For search queries
    cmd = string.format(
      "mpv %s --vo=gpu --hwdec=no --ytdl-format='bestvideo[height<=720]+bestaudio/best[height<=720]' " ..
      "--geometry=%dx%d+%d+%d --no-border --ontop --force-window=yes --window-scale=0.25 " ..
      "--title='ChessNVIM YouTube' --no-terminal " .. 
      "'ytdl://ytsearch:%s' > /dev/null 2>&1 &",
      ytdl_opt, width, height, x_pos, y_pos, url_or_search
    )
  end
  
  -- Execute the command
  local result = os.execute(cmd)
  
  if result then
    vim.notify("▶️ Playing: " .. url_or_search, vim.log.levels.INFO)
  else
    -- If primary method fails, try with even simpler options
    vim.notify("Trying alternate method...", vim.log.levels.WARN)
    
    -- Super simplified fallback command that should work on most systems
    if is_url then
      cmd = string.format(
        "mpv --x11-name='ChessNVIM YouTube' --geometry=+%d+%d --autofit=25%% " ..
        "--ontop --no-border '%s' > /dev/null 2>&1 &",
        x_pos, y_pos, url_or_search
      )
    else
      cmd = string.format(
        "mpv --x11-name='ChessNVIM YouTube' --geometry=+%d+%d --autofit=25%% " ..
        "--ontop --no-border 'ytdl://ytsearch:%s' > /dev/null 2>&1 &",
        x_pos, y_pos, url_or_search
      )
    end
    
    os.execute(cmd)
  end
  
  -- Show controls hint after a short delay
  vim.defer_fn(function()
    vim.notify("Controls: Space=play/pause, m=mute, arrows=seek/volume, q=quit", vim.log.levels.INFO)
  end, 2000)
end

-- Setup function
function M.setup()
  vim.api.nvim_create_user_command("YouTubePlay", function(opts)
    M.play(opts.args)
  end, {nargs = "?"})
  
  vim.api.nvim_create_user_command("YouTubeClose", function()
    M.close()
  end, {})
  
  vim.keymap.set("n", "<leader>yp", ":YouTubePlay ", {desc = "Play YouTube"})
  vim.keymap.set("n", "<leader>yc", ":YouTubeClose<CR>", {desc = "Close YouTube"})
  
  -- Try to register with WhichKey if available
  pcall(function()
    local wk = require("which-key")
    wk.register({
      ["<leader>y"] = { name = "♟️ YouTube", _ = "which_key_ignore" },
      ["<leader>yp"] = { ":YouTubePlay ", "Play YouTube" },
      ["<leader>yc"] = { ":YouTubeClose<CR>", "Close YouTube" },
    })
  end)
  
  vim.notify("♟️ YouTube Player loaded! Use :YouTubePlay to watch videos.", vim.log.levels.INFO)
end

return M
