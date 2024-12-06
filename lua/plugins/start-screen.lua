return {
  {
    "folke/snacks.nvim",
    opts = function()
      -- Helper to determine if in a git repo
      local function in_git()
        local handle = io.popen("git rev-parse --git-dir 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result ~= nil and result ~= ""
        end
        return false
      end

      local function has_git_changes()
        if not in_git() then
          return false
        end

        -- Run git diff to check for changes
        local handle = io.popen("git diff --quiet --exit-code 2>/dev/null; echo $?")
        if handle then
          local result = handle:read("*a")
          handle:close()
          -- If the result is "1", there are changes; "0" means no changes
          return tonumber(result) == 1
        end
        return false
      end

      -- Helper function to determine if it's a GitHub repo
      local function is_github_repo()
        local handle = io.popen("git remote -v 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result:match("github.com") ~= nil
        end
        return false
      end

      -- Helper to get appropriate command based on repo type
      local function get_command(gh_cmd, glab_cmd)
        if is_github_repo() then
          return gh_cmd
        else
          return glab_cmd
        end
      end

      -- Helper to check if there are any PRs/MRs
      local function has_prs_or_mrs()
        if not in_git() then
          return false
        end

        local cmd = get_command("gh pr list --author=@me 2>/dev/null", "glab mr list --author=@me 2>/dev/null")
        local handle = io.popen(cmd)
        if handle then
          local result = handle:read("*a")
          handle:close()
          -- Check if there's any output (excluding headers for glab)
          if is_github_repo() then
            return result ~= ""
          else
            -- For GitLab, skip the header line and check if there's content
            local lines = {}
            for line in result:gmatch("[^\r\n]+") do
              table.insert(lines, line)
            end
            return #lines > 1
          end
        end

        return false
      end

      return {
        dashboard = {
          preset = {
            header = [[
      ██╗███████╗██╗     ██╗     ██╗███████╗██████╗ 
      ██║██╔════╝██║     ██║     ██║██╔════╝╚════██╗
      ██║█████╗  ██║     ██║     ██║███████╗  ▄███╔╝
  ██   ██║██╔══╝  ██║     ██║     ██║╚════██║  ▀▀══╝ 
  ╚█████╔╝███████╗███████╗███████╗██║███████║  ██╗   
  ╚════╝ ╚══════╝╚══════╝╚══════╝╚═╝╚══════╝  ╚═╝   
  ]],
            -- stylua: ignore
            ---@type snacks.dashboard.Item[]
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
              pane = 2,
              icon = is_github_repo() and " " or " ",
              desc = "Browse Repo",
              padding = 1,
              key = "b",
              action = function()
                Snacks.gitbrowse()
              end,
              enabled = in_git(),
            },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 3, padding = 1 },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 3, padding = 1 },
            function()
              local sections = {
                {
                  title = is_github_repo() and "Open PRs" or "Open MRs",
                  cmd = "mrprlist 2>/dev/null",
                  icon = " ",
                  height = 5,
                  indent = 3,
                  enabled = has_prs_or_mrs(),
                },
                {
                  title = "Git Status",
                  cmd = "git --no-pager diff --stat -B -M -C 2>/dev/null",
                  icon = " ",
                  height = 10,
                  enabled = has_git_changes(),
                },
              }

              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  pane = 2,
                  section = "terminal",
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 2,
                }, cmd)
              end, sections)
            end,
            { section = "startup" },
          },
        },
      }
    end,
  },
}
