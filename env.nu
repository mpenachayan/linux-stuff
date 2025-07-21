use std/util "path add"

$env.config.buffer_editor = "code"
$env.config.show_banner = false

$env.HOMEBREW_PREFIX = "/opt/homebrew";
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
$env.HOMEBREW_REPOSITORY = "/opt/homebrew/Homebrew";

path add '/opt/homebrew/bin'
path add "/opt/homebrew/sbin"
path add "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
path add "/opt/homebrew/opt/openjdk@21/bin"
path add "~./docker/bin"

$env.JAVA_HOME = "/opt/homebrew/opt/openjdk@21/"
$env._JAVA_OPTIONS = " -Duser.language=en "

$env.FZF_ALT_C_COMMAND = "fd --type directory --hidden"
$env.FZF_ALT_C_OPTS = "--height=80% --preview 'tree -C {} | head -n 200'"
$env.FZF_CTRL_T_COMMAND = "fd --type file --hidden"
$env.FZF_CTRL_T_OPTS = "--height=80% --preview 'bat --color=always --style=full --line-range=:500 {}' "
$env.FZF_DEFAULT_COMMAND = "fd --type file --hidden"

$env.config.keybindings ++= [
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "do {
          $env.SHELL = '/usr/bin/bash'
          commandline edit --insert (
            history
            | get command
            | reverse
            | uniq
            | str join (char -i 0)
            | fzf --scheme=history 
                --read0
                --layout=reverse
                --height=40%
                --bind 'ctrl-/:change-preview-window(right,70%|right)'
                --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
                # Run without existing commandline query for now to test composability
                # -q (commandline)
            | decode utf-8
            | str trim
          )
        }"
      }
    ]
  }
]

$env.config.keybindings ++=  [
    {
    name: fzf_files
    modifier: control
    keycode: char_t
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: executehostcommand
        cmd: "
          let fzf_ctrl_t_command = \$\"($env.FZF_CTRL_T_COMMAND) | fzf ($env.FZF_CTRL_T_OPTS)\";
          let result = nu -l -i -c $fzf_ctrl_t_command;
          commandline edit --append $result;
          commandline set-cursor --end
        "
      }
    ]
  }
]

$env.config.keybindings ++=  [
  {
    name: fzf_dirs
    modifier: alt
    keycode: char_c
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: executehostcommand
        cmd: "
          let fzf_alt_c_command = \$\"($env.FZF_ALT_C_COMMAND) | fzf ($env.FZF_ALT_C_OPTS)\";
          let result = nu -c $fzf_alt_c_command;
          cd $result;
        "
      }
    ]
}
]

zoxide init nushell | save -f ~/.zoxide.nu
