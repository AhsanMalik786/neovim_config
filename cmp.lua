local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
local col = vim.fn.col "." - 1
return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end


-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
    luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone'
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = true
    }),
  }),
  sources = cmp.config.sources(
    {
      {
        name = 'nvim_lsp'
      },
    },
    {
      {
        name = 'buffer'
      },
    },
    {
      {
        name = "luasnip"
      }
    },
    {
      {
        name = "path"
      }
    }
  ),
  formatting = {
    format = function(entry, vim_item)
    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
    vim_item.menu = ({})[entry.source.name]
    return vim_item
    end
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
})
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    {
      name = 'cmp_git'
    },
  }, {
    {
      name = 'buffer'
    },
  })
})
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {
      name = 'buffer'
    }
  }
})
