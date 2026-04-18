---@module 'lazy'
---@type LazySpec
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  keys = {
    { '<leader>tn', function() require('neotest').run.run() end, desc = '[T]est [N]earest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = '[T]est [F]ile' },
    { '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = '[T]est [A]ll' },
    { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = '[T]est [O]utput' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = '[T]est [S]ummary' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require('neotest-python') {
          runner = function()
            local cfg = vim.g.neotest_python or {}
            return cfg.runner or 'pytest'
          end,
          python = function(root)
            local cfg = vim.g.neotest_python or {}
            if cfg.python then
              if type(cfg.python) == 'function' then
                return cfg.python(root)
              end
              return cfg.python
            end
            return nil
          end,
          args = function(runner)
            local cfg = vim.g.neotest_python or {}
            if cfg.args then
              if type(cfg.args) == 'function' then
                return cfg.args(runner)
              end
              return cfg.args
            end

            if runner == 'unittest' then
              return { '-v' }
            end
            return { '-q' }
          end,
        },
      },
    }
  end,
}
