PROMPT_CHAR="❯"

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$fg[red]%}%{$reset_color%}"

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

function lprompt() {
  local user_privilege="%(!.%{$fg[green]%}.%{$reset_color%})$PROMPT_CHAR"
  local bg_job="%(1j.%{$fg[green]%}.%{$reset_color%})$PROMPT_CHAR"
  local cmd_status="%(0?.%{$fg[green]%}.%{$fg[red]%})$PROMPT_CHAR"
  local suffix="%{$reset_color%} "

  echo "$user_privilege$bg_job$cmd_status$suffix"
}

#source ./path.zsh
function prompt_path() {
  local working_dir="%{$FG[244]%}%2~%{$reset_color%}"

  echo "$working_dir"
}

#source ./git.zsh
# git_prompt_info override
function git_prompt_info() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}


# fastest possible way to check if repo is dirty
prompt_pure_git_dirty() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
  command git diff --quiet --ignore-submodules HEAD &>/dev/null

  (($? == 1)) && echo "$ZSH_THEME_GIT_PROMPT_DIRTY" || echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
}

function cabal_sandbox {
    if [[ -a cabal.sandbox.config ]]
    then
        echo "${ZSH_CABAL_PROMPT_PREFIX}sandbox${ZSH_CABAL_PROMPT_SUFFIX}"
    else
        echo ""
    fi
}

ZSH_CABAL_PROMPT_PREFIX="%{$fg[yellow]%} "
ZSH_CABAL_PROMPT_SUFFIX="%{$reset_color%}"

#git theming settings
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"

function prompt_git() {
  local branch="$(prompt_pure_git_dirty)$(git_prompt_info)%{$reset_color%}"

  echo "$branch"
}


function rprompt() {
  echo "$(vi_mode_prompt_info)$(prompt_path)$(prompt_git)$(cabal_sandbox)"
}

PROMPT='$(lprompt)'
RPROMPT='$(rprompt)'
