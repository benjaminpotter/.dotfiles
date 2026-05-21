
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-------------------------------------------------------------------------------
--- 
--- preferences
---
-------------------------------------------------------------------------------

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.o`
-- For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-------------------------------------------------------------------------------
--- 
--- keymap
---
-------------------------------------------------------------------------------

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-------------------------------------------------------------------------------
--- 
--- autocommands
---
------------------------------------------------------------------------------

-- Configuration for .asy files.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'asy',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Configuration for .tex and similar.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    vim.cmd 'filetype plugin on'
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'bib',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'wgsl',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-------------------------------------------------------------------------------
--- 
--- plugins
---
------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "wincent/base16-nvim",
    lazy = false, -- load at start
    priority = 1000, -- load first
    config = function()
      vim.cmd([[colorscheme gruvbox-dark-hard]])
      vim.o.background = 'dark'
      vim.cmd([[hi Normal ctermbg=NONE]])
      -- Less visible window separator
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = 1250067 })
      -- Make comments more prominent -- they are important.
      local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
      vim.api.nvim_set_hl(0, 'Comment', bools)
      -- Make it clearly visible which argument we're at.
      local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
      vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
      -- XXX
      -- Would be nice to customize the highlighting of warnings and the like to make
      -- them less glaring. But alas
      -- https://github.com/nvim-lua/lsp_extensions.nvim/issues/21
      -- call Base16hi("CocHintSign", g:base16_gui03, "", g:base16_cterm03, "", "", "")
    end
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    config = function()

      vim.lsp.config('rust_analyzer', {
        settings = {
          ['rust_analyzer'] = {
            cargo = { features = "all" },
            checkOnSave = { enable = true },
            check = { command = "clippy" },
            imports = { group = { enable = false } },
            completion = { postfix = { enable = false } },
          }
        }
      })
      vim.lsp.enable('rust_analyzer')

      vim.lsp.config('harper_ls', {
        filetypes = { "markdown", "text", "tex" },
        settings = {
          ["harper-ls"] = {
            userDictPath = "",
            workspaceDictPath = "",
            fileDictPath = "",
            linters = {
              SpellCheck = true,
              SpelledNumbers = false,
              AnA = true,
              SentenceCapitalization = true,
              UnclosedQuotes = true,
              WrongApostrophe = false,
              LongSentences = true,
              RepeatedWords = true,
              Spaces = true,
              CorrectNumberSuffix = true
            },
            codeActions = {
              ForceStable = false
            },
            markdown = {
              IgnoreLinkTitle = false
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "American",
            maxFileLength = 120000,
            ignoredLintsPath = "",
            excludePatterns = {}
          }
        }
      })
      vim.lsp.enable('harper_ls')

      if vim.fn.executable('ruff') == 1 then
        vim.lsp.enable('ruff')
      end

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end

        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
    end,
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    keys = {
      {
        mode = 'n',
        '<leader>o',
        '<cmd>Oil<CR>',
        desc = '[o]pen current directory',
      },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      use_default_keymaps = true,
    },
    -- Optional dependencies
    -- dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },


  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },

  {
    'nvim-mini/mini.align',
    config = function()
      require('mini.align').setup()
    end
  },

  {
    'lervag/vimtex',
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_complete_enabled = 0 
      vim.g.vimtex_quickfix_enabled = 0
    end,
  },

  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = {
      debug = true,
      open_cmd = 'firefox --new-window %s -P typst-preview --class typst-preview',
    }, -- lazy.nvim will implicitly calls `setup {}`
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    -- build = 'cd app && npm install && git reset --hard',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_echo_preview_url = 1
    end,
    ft = { 'markdown' },
  },
})
