(module dotfiles.plugins.comment-plugin)

(defn setup []
  (let [(comment-plugin-ok? comment-plugin)
        (pcall require "Comment")
        (ts-context-commentstring-ok? ts-context-commentstring)
        (pcall require "ts_context_commentstring.integrations.comment_nvim")]
    (when (and comment-plugin-ok? ts-context-commentstring-ok?)
      (comment-plugin.setup {:pre_hook (ts-context-commentstring.create_pre_hook)}))))
