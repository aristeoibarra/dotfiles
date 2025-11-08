-- Custom snippets for React/Next.js/TypeScript
return {
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      -- React functional component
      ls.add_snippets("typescriptreact", {
        s("rfc", {
          t("export default function "),
          i(1, "Component"),
          t("() {"),
          t({"", "  return (", "    <div>"}),
          i(2, "content"),
          t({"</div>", "  )", "}"}),
        }),
      })

      -- useState hook
      ls.add_snippets("typescriptreact", {
        s("ust", {
          t("const ["),
          i(1, "state"),
          t(", set"),
          i(2, "State"),
          t("] = useState"),
          i(3, "<string>"),
          t("("),
          i(4, "''"),
          t(")"),
        }),
      })
    end,
  },
}
