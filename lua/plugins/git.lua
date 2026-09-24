local function open_commit_files(commit, cwd)
  local result = vim.system({
    "git",
    "-c",
    "core.quotepath=false",
    "diff-tree",
    "--no-commit-id",
    "--name-only",
    "-r",
    commit,
  }, { cwd = cwd, text = true }):wait()

  if result.code ~= 0 then
    vim.notify((result.stderr or "git diff-tree failed"):gsub("%s+$", ""), vim.log.levels.ERROR)
    return
  end

  local files = vim.split(result.stdout or "", "\n", { trimempty = true })
  if #files == 0 then
    vim.notify("No files changed in " .. commit, vim.log.levels.INFO)
    return
  end

  local opened, missing = 0, 0
  for _, file in ipairs(files) do
    local full = vim.fs.joinpath(cwd, file)
    if vim.uv.fs_stat(full) then
      vim.cmd.edit(vim.fn.fnameescape(full))
      opened = opened + 1
    else
      missing = missing + 1
    end
  end

  local msg = ("Opened %d file%s from %s"):format(opened, opened == 1 and "" or "s", commit)
  if missing > 0 then
    msg = msg .. (" (%d not in worktree)"):format(missing)
  end
  vim.notify(msg, vim.log.levels.INFO)
end

return {
  { "f-person/git-blame.nvim", opts = { setup = { enabled = false } } },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>go",
        function()
          Snacks.picker.git_log({
            confirm = function(picker, item)
              picker:close()
              if not item or not item.commit then
                vim.notify("No commit selected", vim.log.levels.WARN)
                return
              end

              local cwd = item.cwd or LazyVim.root.git() or vim.fn.getcwd()
              open_commit_files(item.commit, cwd)
            end,
          })
        end,
        desc = "Open files from commit",
      },
    },
  },
}
