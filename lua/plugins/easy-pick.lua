return {
  {
    "axkirillov/easypick.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local base_branch = "develop"
      local easypick = require("easypick")
      easypick.setup({
        pickers = {
          {
            name = "changed_files",
            command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
            previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
          },
          -- list files that have conflicts with diffs in preview
          {
            name = "conflicts",
            command = "git diff --name-only --diff-filter=U --relative",
            previewer = easypick.previewers.file_diff(),
          },
        },
      })
    end,
  },
}
