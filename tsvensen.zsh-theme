# gozilla.zsh-theme humza.zsh-theme sorin.zsh-theme steeef.zsh-theme wedisagree.zsh-theme
# http://www.acm.uiuc.edu/workshops/zsh/prompt/escapes.html

#parse_git_dirty () {
  #[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
#}

#parse_git_branch () {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
#}

#PS1=" \[\e[36;1m\]λ \[$WHITE\]\W\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" [\")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"]\"): \[$RESET\]"

#
# get_pwd()
#
#function get_pwd() {
  #echo "${PWD/$HOME/~}"
#}

#
# add_spacing()
#
#function add_spacing() {
  #local git=$(git_prompt_info)
  #if [ ${#git} != 0 ]; then
    #((git=${#git} - 10))
  #else
    #git=0
  #fi
#
  #local termwidth
  #(( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${bat} - ${git} ))
#
  #local spacing=""
  #for i in {1..$termwidth}; do
    #spacing="${spacing} "
  #done
  ##spacing="${spacing} End"
  #echo $spacing
#}

#
# git_prompt_info()
#
#function git_prompt_info() {
  #ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  #echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
#}





function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  print -D $PWD
}

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
    ((git=${#git} - 25))
  else
    git=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} -  ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done
  echo $spacing
}


#
# precmd()
#
function precmd() {
  print -rP '
  $fg[cyan]%m : $fg[yellow]$(get_pwd)$(put_spacing)$(git_prompt_info)'
}

PROMPT="$reset_color➝  "


#PROMPT="
# $fg[cyan]%m : $fg[yellow]$(get_pwd)$(add_spacing)$(git_prompt_info)
# $reset_color➝  "

ZSH_THEME_GIT_PROMPT_PREFIX=":git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"

# ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+"
# ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✘%{$reset_color%}"


# git|svn theming
# ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"
# ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[red]%}"

# ZSH_THEME_GIT_PROMPT_PREFIX="$fg_bold[green]("
# ZSH_THEME_SVN_PROMPT_PREFIX="$fg_bold[green]("

# ZSH_THEME_GIT_PROMPT_SUFFIX=")"
# ZSH_THEME_SVN_PROMPT_SUFFIX=")"

# ZSH_THEME_GIT_PROMPT_CLEAN="✔"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔ %{$reset_color%}"
# ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%} ✔ %{$reset_color%}"

# ZSH_THEME_GIT_PROMPT_DIRTY="✗"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"
# ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

# ZSH_THEME_GIT_PROMPT_PREFIX=" git:"
#
# ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
# ZSH_THEME_GIT_PROMPT_MODIFIED=" ✹"
# ZSH_THEME_GIT_PROMPT_DELETED=" ✖"
# ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
# ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
# ZSH_THEME_GIT_PROMPT_UNTRACKED=" ✭"
