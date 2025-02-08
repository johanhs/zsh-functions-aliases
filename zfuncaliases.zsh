# mkdir and cd into it
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

# Git stuff

alias gc="git clone"

# (git config list) [ outputs the git config list]
alias gcl="git config --list"

# (git add commit message) [stages all modified/deleted/new files and commits with an optional message]
function gacm {
  git add .;
  if [ ! -n "$1" ]; then
    git commit;
  else
    git commit -m "$1";
  fi
}

# (copy git branch) copies current git branch name to clipboard
alias cgb="cpy git branch --show-current"

function is_in_local() {
    local branch=${1}
    local existed_in_local=$(git branch --list ${branch})

    if [[ -z ${existed_in_local} ]]; then
        echo 0
    else
        echo 1
    fi
}

function is_in_remote() {
    local branch=${1}
    local existed_in_remote=$(git ls-remote --heads origin ${branch})

    if [[ -z ${existed_in_remote} ]]; then
        echo 0
    else
        echo 1
    fi
}

function use_master() {
    local has_local_master=$(git branch --list master);
    if [[ -n ${has_local_master} ]]; then
        return 1;
    else
        return 0;
    fi
}

function use_main() {
  local has_local_main=$(git branch --list main);
  if [[ -n ${has_local_main} ]]; then
      return 1;
  else
      return 0;
  fi
}


function get_real_master {
  local has_local_main=$(git branch --list main);
  local has_local_master=$(git branch --list master);
  local ret_val="";
  if [[ -z $has_local_master && -z $has_local_main ]]; then
    ret_val="has_none";
  elif [[ -n $has_local_master && -n $has_local_main ]]; then
    ret_val="has_both"
  elif [[ -n $has_local_master ]]; then
    ret_val="master";
  elif [[ -n $has_local_main ]]; then
    ret_val="main";
  fi
  echo "$ret_val";
}

# (git check develop upstrem)
function gcdu {
  git fetch origin develop;
  local develop_sha=$(git rev-parse develop);
  local origin_develop_sha=$(git rev-parse origin/develop);

  if [ "$develop_sha" = "$origin_develop_sha" ]; then
    echo "develop branch is up to date with origin!"
  else
    echo "New updates to pull on develop!"
  fi
}

# (git check fork upstrem)
function gcfu {
  git fetch upstream develop;
  local develop_sha=$(git rev-parse develop);
  local upstream_develop_sha=$(git rev-parse upstream/develop);

  if [ "$develop_sha" = "$upstream_develop_sha" ]; then
    echo "develop branch is up to date with upstream!"
  else
    echo "New updates to sync on upstream develop!"
  fi
}

# (git check current fork upstrem)
function gccfu {
  local currentBranchName=$(git branch --show-current);
  local currentBranchSha=$(git rev-parse $currentBranchName);
  echo "$currentBranchName";
  echo "$currentBranchSha";
  git fetch upstream $currentBranchName;
}

function gcu {
  local repo_master=$(get_real_master);
  if [[ -z $repo_master ]]; then
    echo "unknown!";
  elif [[ $repo_master == "has_none" || $repo_master == "has_both" ]]; then
    echo "$repo_master";
  else
    git fetch origin $repo_master;
    local master_sha=$(git rev-parse $repo_master);
    local origin_master_sha=$(git rev-parse origin/$repo_master);
    if [ "$master_sha" = "$origin_master_sha" ]; then
      echo "$repo_master is up to date with origin!"
    else
      echo "New updates to pull on $repo_master!"
    fi
  fi
}

function gccu {
  currentBranchName=$(git branch --show-current);
  currentBranchSha=$(git rev-parse "$currentBranchName");
  git fetch origin "$currentBranchName";
  currentOriginBranchSha=$(git rev-parse origin/"$currentBranchName");
  if [ "$currentBranchSha" = "$currentOriginBranchSha" ]; then
    echo ""$currentBranchName" is up to date with origin!"
  else
    echo "New updates to pull on "$currentBranchName"!"
  fi
}

alias gru="git remote update"
alias grvu="git remote -v update"

# Show all local and remote branches
alias gba="git branch -a"

# Show all local and remote branches verbose
alias gbav="git branch -a -v"

# (Git Push New) branch
# push current branch to upstream
function gpn {
  workingbranch=$(git branch | grep '^\*' | cut -d' ' -f2);
  git push --set-upstream origin "$workingbranch"
}

# (Git Add Stash)
# stage all and stash (in order for newly created files to get stashed)
alias gas="git add . && git stash"

# (Git Add Stash Message)
# stage all, stash changes and save with name
alias gasm="git add . && git stash push -m"


# (Git Add Stash Rebase Master)
# stash current working branch changes, switch to master, pull, switch back and rebases it on master/main and pop
function gasrm {
  local repo_master=$(get_real_master);
  if [[ -z $repo_master ]]; then
    echo "unknown!";
  elif [[ $repo_master == "has_none" || $repo_master == "has_both" ]]; then
    echo "$repo_master";
  else
    workingbranch=$(git branch | grep '^\*' | cut -d' ' -f2);
    git add .;
    git stash;
    git checkout $repo_master;
    git pull;
    git checkout "$workingbranch";
    git rebase $repo_master;
    git stash pop;
  fi
}

# (Git Rebase Pulled Master)
# switch to master, pull, switch back and rebases it on master
function grpm {
  local repo_master=$(get_real_master);
  if [[ -z $repo_master ]]; then
    echo "unknown!";
  elif [[ $repo_master == "has_none" || $repo_master == "has_both" ]]; then
    echo "$repo_master";
  else
    workingbranch=$(git branch | grep '^\*' | cut -d' ' -f2);
    git checkout $repo_master;
    git pull;
    git checkout "$workingbranch";
    git rebase $repo_master;
  fi
}

# (git stash apply message)
# Apply specific stash by name
function gsam {
  if [ ! -n "$1" ]; then
    echo "Enter stash name to apply"
  else
    stashindex=$(git stash list | grep "$1" | cut -f 1 -d ':' | grep -o -E '[0-9]+');
    git stash apply "$stashindex"
  fi
}

# (discard all changes)
# Discard all staged and working directory changes
alias dac="git reset --hard"

# (discard all files)
# Discard all untracked files/folders
alias daf="git clean -df"

# (discard all files & changes)
# Discard all staged and working directory changes + all untracked files/folders
alias dafc="git reset --hard && git clean -df"

# (discard all changes pull)
# Discard all staged and working directory changes and pull
alias dacpl="git reset --hard && git pull"

# (git checkout master or main) 
function gcom {
  local repo_master=$(get_real_master);
  if [[ -z $repo_master ]]; then
    echo "unknown!";
  elif [[ $repo_master == "has_none" || $repo_master == "has_both" ]]; then
    echo "$repo_master";
  else
    git checkout $repo_master;
  fi
}

# (git merge continue)
alias gmc="git merge --continue"

# (git rebase master or main)
function grm {
  local repo_master=$(get_real_master);
  if [[ -z $repo_master ]]; then
    echo "unknown!";
  elif [[ $repo_master == "has_none" || $repo_master == "has_both" ]]; then
    echo "$repo_master";
  else
    git rebase ${repo_master};
  fi
}

alias gpl="git pull"
alias gra='git rebase --abort'
alias grc="git rebase --continue"

alias gs="git stash"
alias gsl="git stash list"
alias gss="git stash show"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias gsd="git stash drop"
alias gst="git status"
alias ga="git add ."

# (git commit no-verify) commit without pre-commit and commit-msg check hooks
alias gcn="git commit -n"

# (git commit ammend) add to previous commit
alias gca="git commit --amend"

# add to previous commit  without flow checek
alias gcan="git commit --amend -n"

# (git add commit amend) stage all changes and add to previous commit
alias gaca="git add . && git commit --amend"

# (git add commit amend no-verify)
alias gacan="git add . && git commit --amend -n"

alias gp="git push"
alias gpfl="git push --force-with-lease"
alias gpr='git pull --rebase'

# PS
alias psa="ps aux"
alias psg="ps aux | grep "
alias psr='ps aux | grep ruby'

# show me files matching "ls grep"
alias lsg='ll | grep'

# === Custom stuff => ===

# Echo stuff
alias ep='echo $PATH'

# Quicktype - generate Typescript types from JSON file
function qt {
  if [ ! -n "$1" ]; then
    echo "Enter JSON file to generate Typescript file"
  else
    quicktype "$1" -o ${1%.json}.ts --just-types
  fi
}

# (Log Program Info)
# Will log version and path including symbolic links
function lpi {
  if [ ! -n "$1" ]; then
    echo "Enter package/program to get info about"
  else
    whichPath=$(which $1);
    realPath=$(ll $whichPath);
    pVersion=$($1 --version);
    echo "$pVersion";
    echo "$realPath";
  fi
}

# (copy argument output without last trailing new line)
function cpy {
  if [ ! -n "$1" ]; then
    echo "Enter something to copy without newlines"
  else
    echo -n "$($@)" | pbcopy
  fi
}

# (copy argument output formatted without any ANSI escape characters)
function cpyf {
  if [ ! -n "$1" ]; then
    echo "Enter something to copy without ANSI escape characters";
  else
    echo -n "$($@)" | ansifilter | col -b -x | pbcopy;
  fi
}

# (Copy Path)
alias cpyp="cpy pwd"

alias st='open -a SourceTree'

function getParentFolderName {
  currentPathRev="$(pwd | rev)";
  revParentFolderName=$(cut -d '/' -f2 <<<"$currentPathRev");
  parentFolderName="$(echo $revParentFolderName | rev)";
  echo "$parentFolderName"
}

# show process top cpu
alias topcpu="top -o cpu"

# Get open ports and with which arguments it's run
function openports () {
  netstat -Watnlv | grep LISTEN | awk '{"ps -ww -o args= -p " $9 | getline procname;colred="\033[01;31m";colclr="\033[0m"; print colred "proto: " colclr $1 colred " | addr.port: " colclr $4 colred " | pid: " colclr $9 colred " | name: " colclr procname;  }' | column -t -s "|"
}

# list much more, open files, processes, ports etc
alias rootprocesses="sudo lsof -i -n -P"

# list files that are open ports, PID is second column
alias openrootports="sudo lsof -i -n -P | grep -i listen"

# (List All Processes)
alias lap="ps aux"

# (Kill Process By Id)
# kill a process by PID
alias kpbi="kill -9"

# (Get Folder Size)
function gfs {
  if [ ! -n "$1" ]; then
    sajz=$(find . -type f -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}');
    echo "$sajz";
  else
    inputFolderSize=$(find $1 -type f -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}');
    echo "$inputFolderSize";
  fi
}

# (Get Folder Files)
function gff {
  if [ ! -n "$1" ]; then
    numberOfFiles=$(find . -mindepth 1 -type f | wc -l);
    echo "$numberOfFiles";
  else
    inputNumberOfFiles=$(find $1 -mindepth 1 -type f | wc -l);
    echo "$inputNumberOfFiles";
  fi
}

# (get folder sub directories)
function gfsd {
  if [ ! -n "$1" ]; then
    numberOfSubDirectories=$(find . -mindepth 1 -type d | wc -l);
    echo "$numberOfSubDirectories";
  else
    inputNumberOfSubDirectories=$(find $1 -mindepth 1 -type d | wc -l);
    echo "$inputNumberOfSubDirectories";
  fi
}

alias jus="jest --updateSnapshot"

# --- node / VVM stuff
alias nv="node -v"
alias nud="nvm use default"
alias nul="nvm use latest"
alias nlr="nvm ls-remote"

# (nvm install latest default) checks if there is a new LTS version of node and installs it if so, and sets it as default
function nild {
  local znvmltsline=$(nvm ls-remote | grep "(Latest LTS:" | tail -1);
  if [[ $znvmltsline = *"->"* ]]; then
    echo "Already have latest version!";
  else
    echo "Don't have the latest node version!";
    local zversionStr="v";
    local zdotStr=".";
    local zindexOfVersion=${znvmltsline[(i)$zversionStr]};
    local zindexOfLastDot=${znvmltsline[(I)$zdotStr]};
    local zindexOfLastPossibleNumber=$(($zindexOfLastDot + 2));
    local znvmVersionToLastPossibleMinorNumber=${znvmltsline[$zindexOfVersion, $zindexOfLastPossibleNumber]};
    local zlastPositionOfMinorVersionNumber=${znvmVersionToLastPossibleMinorNumber[(I)[0-9]]};
    local znvmVersion=${znvmVersionToLastPossibleMinorNumber[0, $zlastPositionOfMinorVersionNumber]};
    nvm install $znvmVersion;
    nvm unalias default;
    nvm alias default $znvmVersion;
    echo "Done installing and changing alias default to: $znvmVersion";
  fi
}

# (List Package.json Scripts)
alias lps="cat package.json | jq '.scripts'"

# --- NPM stuff

alias nout="npm outdated"

# npm
function nie {
  if [ ! -n "$1" ]; then
    echo "enter npm dependency package to install exact"
  else
    npm install --save-exact "$1@latest"
  fi
}

function nide {
  if [ ! -n "$1" ]; then
    echo "enter npm devDependency package to install exact"
  else
    npm install --save-dev --save-exact "$1@latest"
  fi
}

# (npm list global) list global npm packages
alias ngl="npm list -g --depth 0"
alias ni="npm install"
alias nd="npm run dev"
alias ns="npm run start"
alias nb="npm run build"
# see info about packages
alias pck="npx depcheck";

# see issues with webpack
alias wck="node --trace-deprecation node_modules/webpack/bin/webpack.js"

# --- Brew stuff
alias bout="brew outdated"

# --- Yarn stuff
alias yv="yarn --version"
alias y="yarn install"
alias yi="yarn install"
alias yif="yarn install --force"
alias ys="yarn start"
alias yd="yarn dev"
alias ycc="yarn cache clean"

alias yw="yarn why"
alias nls="npm list"

function yp {
  if [ ! -n "$1" ]; then
    echo "Enter package name to see why it's installed"
  else
  yarn why $1;
  npm list $1;
  fi
}

alias yout="yarn outdated"
alias yul="yarn upgrade --latest"
alias yui="yarn upgrade-interactive"


# yarn start new port
alias ysn="PORT=3001 yarn start"

# (yarn list current)
# list all dependencies for the current working directory by referencing all package manager meta data files, which includes a project’s dependencies.
alias ylc="yarn list"

# (yarn list global)
# list all global installed packages
# alias ylg="yarn global list"
alias yga="yarn global add"
alias ygl="yarn global list"

# (remove node_modules yarn) remove node_modules and yarn install
alias rny="rm -rf node_modules && yarn install"

alias rnly="rm -rf yarn.lock && rm -rf node_modules && yarn install"

alias yl="yarn lint"

alias yb="yarn build"
alias ya="yarn add"
alias yad="yarn add -D"

alias yae="yarn add -E"
alias yade="yarn add -D -E"

alias yrm="yarn remove"

# Open VS Code in current folder (you have to add code symbolic link to your path)
alias c="code ."

# ======== Hardhat STUFF ========
alias nhc='npx hardhat compile'
alias nht='npx hardhat test'
