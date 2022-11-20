# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

PS1="%{$fg[cyan]%}[${USER}@${HOST%%.*} %1~]%(!.#.$)${reset_color} "

#---------------------------------------------------------------------#
#                   base setting                                      #
#---------------------------------------------------------------------#

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups

# キーバインド
bindkey -e
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

export SHELL=/usr/bin/zsh

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#---------------------------------------------------------------------#
#                   base setting fin                                  #
#---------------------------------------------------------------------#

#---------------------------------------------------------------------#
#                   plugins                                           #
#---------------------------------------------------------------------#

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# plugins
zinit ice depth=1
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/history-search-multi-word

#---------------------------------------------------------------------#
#                   plugins fin                                       #
#---------------------------------------------------------------------#

#---------------------------------------------------------------------#
#                   function                                          #
#---------------------------------------------------------------------#

# fzfをパスに追加
export PATH=$PATH:~/.fzf/bin

# fzfを使用したgit branchの切り替え
function select-git-switch() {
target_br=$(
git branch -a |
	fzf --exit-0 --layout=reverse --info=hidden --no-multi --preview-window="right,65%" --prompt="CHECKOUT BRANCH > " --preview="echo {} | tr -d ' *' | xargs git log --color=always" |
	head -n 1 |
	perl -pe "s/\s//g; s/\*//g; s/remotes\/origin\///g"

)
if [ -n "$target_br"  ]; then
	BUFFER="git switch $target_br"
	zle accept-line
fi

}
zle -N select-git-switch
bindkey "^g" select-git-switch # 「control + G」で実行

# fzfを使用してファイルをnvimで開く
function fnv() {
	local file
	file=$(find . | fzf)
	if [ -n "$file" ]; then
		nvim "$file"
	fi
}

# fzfを使用してパターンを含むファイルをnvimで開く
function fnvrg() {
	local file
	file=$(rg $1 | fzf | cut -d ":" -f 1)
	if [ -n "$file" ]; then
		nvim "$file"
	fi
}

# fzfを使用してコンテナ名を指定してdocker execを実行する
function dox() {
	local cname
	cname=$(docker ps --format "{{.Names}}" | fzf)
	if [ -n "$cname" ]; then
	docker exec -it "$cname" bash
	fi
}

# fzfを使用してコンテナ名を指定してdocker logを出力する
function dol() {
	local cname
	cname=$(docker ps --format "{{.Names}}" | fzf)
	if [ -n "$cname" ]; then
	docker logs --tail=500 "$cname"
	fi
}

# fzfを使用してコンテナ名を指定してdocker logを-fオプションで出力する
function dolf() {
	local cname
	cname=$(docker ps --format "{{.Names}}" | fzf)
	if [ -n "$cname" ]; then
	docker logs -f "$cname"
	fi
}

# fzfを使用して停止中のコンテナ名を任意の個数指定してdocker startする
function dostart() {
	local cnames
	cnames=$(docker ps --all --filter "status=exited" --filter "status=paused" --format "{{.Names}}" | fzf -m --bind=ctrl-a:toggle-all)
	if [ -n "$cnames" ]; then
		echo "$cnames" | xargs docker start
	fi
}

# fzfを使用して起動中のコンテナ名を任意の個数指定してdocker stopする
function dostop() {
	local cnames
	cnames=$(docker ps --all --filter "status=running" --format "{{.Names}}" | fzf -m --bind=ctrl-a:toggle-all)
	if [ -n "$cnames" ]; then
		echo "$cnames" | xargs docker stop
	fi
}

# fzfを使用して停止中のコンテナ名を任意の個数指定してdocker rmする
function dorm() {
	local cnames
	cnames=$(docker ps --all --filter "status=exited" --filter "status=paused" --format "{{.Names}}" | fzf -m --bind=ctrl-a:toggle-all)
	if [ -n "$cnames" ]; then
		echo "$cnames" | xargs docker rm
	fi
}

#---------------------------------------------------------------------#
#                   functions fin                                     #
#---------------------------------------------------------------------#