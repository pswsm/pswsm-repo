# Theme:  pswsm's theme
# Made by pswsm
# Web:    https://pswsm.cat

#colors
reset="%f%k"
blau="%F{32}"
verd="%F{10}"
roig_git="%K{160} %F{0}"
verd_git="%K{10} %F{0}"

function get_salute () {
  if [ `date +%H` -ge 12 ] && [ `date +%H` -le 19 ]; then
    echo -e "こんばんわ"
  elif [ `date +%H` -ge 20 ] || [ `date +%H` -le 6 ]; then
    salute="おやすみ"
  elif [ `date +%H` -ge 7 ] && [ `date +%H` -le 11 ]; then
    salute="おはよう"
  fi
}


#Git BS
ZSH_THEME_GIT_PROMPT_PREFIX="lechuga || "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$verd_git%}ツ%{$reset%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$roig_git%}※%{$reset%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset%}"

#Prompt BS
PS1='%{$reset%}%D{%K}時%D{%m}分 $(get_salute) %{$verd%}%n%{$reset%}
%/ ==> ' 
RPS1='$(git_prompt_info)'
