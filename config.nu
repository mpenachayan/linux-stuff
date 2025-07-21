source ~/.zoxide.nu

# Aliases
alias ll = ls -lt
alias vim = nvim
alias vi = nvim
alias cat = bat
alias gc = git checkout 
alias gcm = git checkout main 
alias gcb = git checkout -b 
alias gc = git commit -m
alias gp = git pull 
alias gpm = git pull origin main 
alias gpr = git pull origin main --rebase 
alias gph = git pull origin HEAD 
alias grs = git reset --soft HEAD~1 
alias grh = git reset --hard HEAD 
alias gph = git push origin HEAD 
alias gphf = git push origin HEAD --force 

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

def git-tag-with-datetime [] {
    let last_tag = (git describe --tags --abbrev=0 | str trim)
    let datetime = (date now | format date "%y%m%d%H%M")
    let result = $"($last_tag).($datetime)"
    echo $result
}

def gh-prerelease [] {
    let tag = (git-tag-with-datetime)
    let commit = (git rev-parse HEAD | str trim)
    gh release create $tag --target $commit --prerelease --notes $tag --latest=false
}

def gh-release [tag_name: string] {
    if ($tag_name | is-empty) {
        print "Por favor, proporciona un nombre de tag como parámetro."
        return 1
    }
    let commit = (git rev-parse HEAD | str trim)
    gh release create $tag_name --target $commit --generate-notes --latest
}

def git-delete-all-branches [] {
    let current = (git rev-parse --abbrev-ref HEAD | str trim)
    for branch in (git branch --format '%(refname:short)' | lines | each {|x| $x | str trim }) {
        if $branch != $current {
            git branch -D $branch
        }
    }
}
