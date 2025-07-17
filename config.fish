if test -f "/opt/homebrew/bin/brew"
    # Homebrew is installed on MacOS
    /opt/homebrew/bin/brew shellenv | source
end

oh-my-posh init fish --config ~/.local/share/oh-my-posh/mytheme.omp.yaml | source
zoxide init fish | source
# Set up fzf key bindings
fzf --fish | source

# Usar fzf para autocompletar historial de comandos
function fzf-history-widget
    set cmd (history | fzf --tac --preview "echo {}")
    if test -n "$cmd"
        commandline -f repaint
        commandline -i "$cmd"
    end
end

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias vi='nvim'
alias ll="ls -lt"
alias cat="bat"
alias gc="git checkout "
alias gcm="git checkout main "
alias gcb="git checkout -b "
alias gc='git commit -m '
alias gp="git pull "
alias gpm="git pull origin main "
alias gpr="git pull origin main --rebase "
alias gph="git pull origin HEAD "
alias grs="git reset --soft HEAD~1 "
alias grh="git reset --hard HEAD "
alias gph="git push origin HEAD "
alias gphf="git push origin HEAD --force "

set -gx _JAVA_OPTIONS '-Duser.language=en'
fish_add_path '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
fish_add_path "$HOMEBREW_PREFIX/opt/openjdk@21/bin"
set -gx JAVA_HOME "$HOMEBREW_PREFIX/opt/openjdk@21/"

if status is-interactive
    # Commands to run in interactive sessions can go here
end
