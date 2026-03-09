# Abbreviations

# ls
abbr -a ll 'ls -alF'
abbr -a la 'ls -A'
abbr -a l 'ls -CF'

# Shell
abbr -a exsh 'exec fish'
abbr -a es 'exec fish'

# Git
abbr -a gb 'git branch'
abbr -a gs 'git switch'
abbr -a gsp 'git-switch-peco'
abbr -a gp 'git push'
abbr -a gpl 'git pull'
abbr -a gst 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gm 'git merge'
abbr -a grom 'git fetch; and git rebase origin/master'
abbr -a gsh 'git_branch_history.sh'

# Git worktree jump with peco
abbr -a gwj 'source ~/bin/git-worktree-jump.sh'

# Tools
abbr -a bers 'bundle exec rspec'
abbr -a pex 'pet exec'
abbr -a ped 'pet edit'
abbr -a lg 'lazygit'
abbr -a wrc 'command wrc check --watch'

# Claude Code
abbr -a cb 'claude --permission-mode bypassPermissions'
abbr -a ccb 'claude -c --permission-mode bypassPermissions'

# Gemini CLI
abbr -a gemini 'npx https://github.com/google-gemini/gemini-cli'

# GCloud (gca to avoid conflict with git add)
abbr -a gca 'gcloud auth list --format="value(account)" | peco | xargs -I {} gcloud config set account {}'
abbr -a gpr 'gcloud projects list --format="value(project_id)" | peco | xargs -I {} gcloud config set project {}'

# AWS
abbr -a apr 'set -gx AWS_PROFILE (aws configure list-profiles | peco --prompt "AWS Profile > ")'

# Kubectl
abbr -a ka 'kubectl config get-contexts -o name | peco | xargs -I {} kubectl config use-context {}'
abbr -a k 'kubectl'

# Devcontainer
abbr -a dewf 'devcontainer exec --workspace-folder .'

# Open file with editor using peco
if command -q peco
    if test "$IS_MACOS" = true; and command -q cursor
        abbr -a cind 'cursor (find . -type f | peco)'
    else if command -q code
        abbr -a cind 'code (find . -type f | peco)'
    else
        abbr -a vind 'vim (find . -type f | peco)'
    end
end

# Clipboard (platform-aware)
if test "$IS_MACOS" = true
    # macOS has pbcopy/pbpaste built-in
else if test "$IS_WSL" = true
    abbr -a pbcopy 'clip.exe'
    abbr -a pbpaste 'powershell.exe -command "Get-Clipboard" | tr -d "\r"'
else if command -q xclip
    abbr -a pbcopy 'xclip -selection clipboard'
    abbr -a pbpaste 'xclip -selection clipboard -o'
end
