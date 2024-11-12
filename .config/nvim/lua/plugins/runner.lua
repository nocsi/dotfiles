return {
  "CRAG666/code_runner.nvim",
  event = "VeryLazy",
  config = function()
    opts = {
      startInsert = true,
      filetype = {
        javascript = "node",
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        cpp = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
        python = "python -u",
        sh = "bash",
        rust = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
      },
    }
  end,
}
