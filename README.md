# Zsh Functions and Aliases

This repository contains a collection of useful Zsh functions and aliases to streamline your workflow in many different areas. Some very useful git functions when working with Git and large projects with frequent updates.

## Git Functions and Aliases

- `gc`: Clone a Git repository.
  ```sh
  alias gc="git clone"
  ```

- `gcl`: Outputs the Git config list.
  ```sh
  alias gcl="git config --list"
  ```

- `gacm`: Stages all modified/deleted/new files and commits with an optional message.
  ```sh
  function gacm {
    git add .;
    if [ ! -n "$1" ]; then
      git commit;
    else
      git commit -m "$1";
    fi
  }
  ```

- `cgb`: Copies the current Git branch name to the clipboard.
  ```sh
  alias cgb="cpy git branch --show-current"
  ```

- `gcu`: Checks if the master/main branch is up to date with origin.
  ```sh
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
  ```

- `gccu`: Checks if the current branch is up to date with origin.
  ```sh
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
  ```

- `gpn`: Pushes the current branch to upstream.
  ```sh
  function gpn {
    workingbranch=$(git branch | grep '^\*' | cut -d' ' -f2);
    git push --set-upstream origin "$workingbranch"
  }
  ```

- `gasrm`: Stashes current changes, switches to master/main, pulls, switches back, rebases, and pops the stash.
  ```sh
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
  ```

- `grpm`: Switches to master/main, pulls, switches back, and rebases.
  ```sh
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
  ```

- `dac`: Discards all staged and working directory changes.
  ```sh
  alias dac="git reset --hard"
  ```

- `daf`: Discards all untracked files/folders.
  ```sh
  alias daf="git clean -df"
  ```

- `dafc`: Discards all staged and working directory changes + all untracked files/folders.
  ```sh
  alias dafc="git reset --hard && git clean -df"
  ```

- `dacpl`: Discards all staged and working directory changes and pulls.
  ```sh
  alias dacpl="git reset --hard && git pull"
  ```

- `gcom`: Checks out the master or main branch.
  ```sh
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
  ```

- `grm`: Rebases the current branch on master or main.
  ```sh
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
  ```

- `gpl`: Pulls the latest changes from the remote repository.
  ```sh
  alias gpl="git pull"
  ```

- `gra`: Aborts the current rebase operation.
  ```sh
  alias gra='git rebase --abort'
  ```

- `grc`: Continues the current rebase operation.
  ```sh
  alias grc="git rebase --continue"
  ```

- `gs`: Stashes the current changes.
  ```sh
  alias gs="git stash"
  ```

- `gsl`: Lists all stashes.
  ```sh
  alias gsl="git stash list"
  ```

- `gss`: Shows the changes in the latest stash.
  ```sh
  alias gss="git stash show"
  ```

- `gsa`: Applies the latest stash.
  ```sh
  alias gsa="git stash apply"
  ```

- `gsp`: Pops the latest stash.
  ```sh
  alias gsp="git stash pop"
  ```

- `gsd`: Drops the latest stash.
  ```sh
  alias gsd="git stash drop"
  ```

- `gst`: Shows the status of the working directory.
  ```sh
  alias gst="git status"
  ```

- `ga`: Stages all changes.
  ```sh
  alias ga="git add ."
  ```

- `gcn`: Commits without pre-commit and commit-msg check hooks.
  ```sh
  alias gcn="git commit -n"
  ```

- `gca`: Amends the previous commit.
  ```sh
  alias gca="git commit --amend"
  ```

- `gcan`: Amends the previous commit without pre-commit and commit-msg check hooks.
  ```sh
  alias gcan="git commit --amend -n"
  ```

- `gaca`: Stages all changes and amends the previous commit.
  ```sh
  alias gaca="git add . && git commit --amend"
  ```

- `gacan`: Stages all changes and amends the previous commit without pre-commit and commit-msg check hooks.
  ```sh
  alias gacan="git add . && git commit --amend -n"
  ```

- `gp`: Pushes the current branch to the remote repository.
  ```sh
  alias gp="git push"
  ```

- `gpfl`: Pushes the current branch to the remote repository with force and lease.
  ```sh
  alias gpfl="git push --force-with-lease"
  ```

- `gpr`: Pulls the latest changes from the remote repository with rebase.
  ```sh
  alias gpr='git pull --rebase'
  ```

## Process Management

- `psa`: Lists all running processes.
  ```sh
  alias psa="ps aux"
  ```

- `psg`: Searches for a process by name.
  ```sh
  alias psg="ps aux | grep "
  ```

- `psr`: Searches for Ruby processes.
  ```sh
  alias psr='ps aux | grep ruby'
  ```

- `topcpu`: Shows processes sorted by CPU usage.
  ```sh
  alias topcpu="top -o cpu"
  ```

- `openports`: Lists open ports and the processes using them.
  ```sh
  function openports () {
    netstat -Watnlv | grep LISTEN | awk '{"ps -ww -o args= -p " $9 | getline procname;colred="\033[01;31m";colclr="\033[0m"; print colred "proto: " colclr $1 colred " | addr.port: " colclr $4 colred " | pid: " colclr $9 colred " | name: " colclr procname;  }' | column -t -s "|"
  }
  ```

- `rootprocesses`: Lists open files, processes, and ports.
  ```sh
  alias rootprocesses="sudo lsof -i -n -P"
  ```

- `openrootports`: Lists files that are open ports.
  ```sh
  alias openrootports="sudo lsof -i -n -P | grep -i listen"
  ```

- `lap`: Lists all processes.
  ```sh
  alias lap="ps aux"
  ```

- `kpbi`: Kills a process by PID.
  ```sh
  alias kpbi="kill -9"
  ```

## File and Directory Management

- `mkcd`: Creates a directory and changes into it.
  ```sh
  function mkcd {
    if [ ! -n "$1" ]; then
      echo "Enter a directory name"
    elif [ -d $1 ]; then
      echo "\`$1' already exists"
    else
      mkdir $1 && cd $1
    fi
  }
  ```

- `lsg`: Lists files matching a pattern.
  ```sh
  alias lsg='ll | grep'
  ```

- `getParentFolderName`: Gets the name of the parent folder.
  ```sh
  function getParentFolderName {
    currentPathRev="$(pwd | rev)";
    revParentFolderName=$(cut -d '/' -f2 <<<"$currentPathRev");
    parentFolderName="$(echo $revParentFolderName | rev)";
    echo "$parentFolderName"
  }
  ```

- `gfs`: Gets the size of a folder.
  ```sh
  function gfs {
    if [ ! -n "$1" ]; then
      sajz=$(find . -type f -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}');
      echo "$sajz";
    else
      inputFolderSize=$(find $1 -type f -print0 | xargs -0 stat -f%z | awk '{b+=$1} END {print b}');
      echo "$inputFolderSize";
    fi
  }
  ```

- `gff`: Gets the number of files in a folder.
  ```sh
  function gff {
    if [ ! -n "$1" ]; then
      numberOfFiles=$(find . -mindepth 1 -type f | wc -l);
      echo "$numberOfFiles";
    else
      inputNumberOfFiles=$(find $1 -mindepth 1 -type f | wc -l);
      echo "$inputNumberOfFiles";
    fi
  }
  ```

- `gfsd`: Gets the number of subdirectories in a folder.
  ```sh
  function gfsd {
    if [ ! -n "$1" ]; then
      numberOfSubDirectories=$(find . -mindepth 1 -type d | wc -l);
      echo "$numberOfSubDirectories";
    else
      inputNumberOfSubDirectories=$(find $1 -mindepth 1 -type d | wc -l);
      echo "$inputNumberOfSubDirectories";
    fi
  }
  ```

## Node and NPM Management

- `nv`: Shows the Node.js version.
  ```sh
  alias nv="node -v"
  ```

- `nud`: Uses the default Node.js version.
  ```sh
  alias nud="nvm use default"
  ```

- `nul`: Uses the latest Node.js version.
  ```sh
  alias nul="nvm use latest"
  ```

- `nlr`: Lists remote Node.js versions.
  ```sh
  alias nlr="nvm ls-remote"
  ```

- `nild`: Installs the latest LTS version of Node.js and sets it as default.
  ```sh
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
      local znvmVersionToLastPossibleMinorNumber=${znvmltsline[$zversionStr, $zindexOfLastPossibleNumber]};
      local zlastPositionOfMinorVersionNumber=${znvmVersionToLastPossibleMinorNumber[(I)[0-9]]};
      local znvmVersion=${znvmVersionToLastPossibleMinorNumber[0, $zlastPositionOfMinorVersionNumber]};
      nvm install $znvmVersion;
      nvm unalias default;
      nvm alias default $znvmVersion;
      echo "Done installing and changing alias default to: $znvmVersion";
    fi
  }
  ```

- `lps`: Lists scripts in package.json.
  ```sh
  alias lps="cat package.json | jq '.scripts'"
  ```

- `nout`: Lists outdated npm packages.
  ```sh
  alias nout="npm outdated"
  ```

- `nie`: Installs an npm dependency package with exact version.
  ```sh
  function nie {
    if [ ! -n "$1" ]; then
      echo "enter npm dependency package to install exact"
    else
      npm install --save-exact "$1@latest"
    fi
  }
  ```

- `nide`: Installs an npm devDependency package with exact version.
  ```sh
  function nide {
    if [ ! -n "$1" ]; then
      echo "enter npm devDependency package to install exact"
    else
      npm install --save-dev --save-exact "$1@latest"
    fi
  }
  ```

- `ngl`: Lists global npm packages.
  ```sh
  alias ngl="npm list -g --depth 0"
  ```

- `ni`: Installs npm packages.
  ```sh
  alias ni="npm install"
  ```

- `nd`: Runs npm dev script.
  ```sh
  alias nd="npm run dev"
  ```

- `ns`: Runs npm start script.
  ```sh
  alias ns="npm run start"
  ```

- `nb`: Runs npm build script.
  ```sh
  alias nb="npm run build"
  ```

- `pck`: Checks for unused npm packages.
  ```sh
  alias pck="npx depcheck"
  ```

- `wck`: Checks for issues with webpack.
  ```sh
  alias wck="node --trace-deprecation node_modules/webpack/bin/webpack.js"
  ```

## Yarn Management

- `yv`: Shows the Yarn version.
  ```sh
  alias yv="yarn --version"
  ```

- `y`: Installs Yarn packages.
  ```sh
  alias y="yarn install"
  ```

- `yi`: Installs Yarn packages.
  ```sh
  alias yi="yarn install"
  ```

- `yif`: Installs Yarn packages with force.
  ```sh
  alias yif="yarn install --force"
  ```

- `ys`: Runs Yarn start script.
  ```sh
  alias ys="yarn start"
  ```

- `yd`: Runs Yarn dev script.
  ```sh
  alias yd="yarn dev"
  ```

- `ycc`: Cleans Yarn cache.
  ```sh
  alias ycc="yarn cache clean"
  ```

- `yw`: Shows why a package is installed.
  ```sh
  alias yw="yarn why"
  ```

- `nls`: Lists npm packages.
  ```sh
  alias nls="npm list"
  ```

- `yp`: Shows why a package is installed.
  ```sh
  function yp {
    if [ ! -n "$1" ]; then
      echo "Enter package name to see why it's installed"
    else
    yarn why $1;
    npm list $1;
    fi
  }
  ```

- `yout`: Lists outdated Yarn packages.
  ```sh
  alias yout="yarn outdated"
  ```

- `yul`: Upgrades Yarn packages to the latest version.
  ```sh
  alias yul="yarn upgrade --latest"
  ```

- `yui`: Interactively upgrades Yarn packages.
  ```sh
  alias yui="yarn upgrade-interactive"
  ```

- `ysn`: Runs Yarn start script on a new port.
  ```sh
  alias ysn="PORT=3001 yarn start"
  ```

- `ylc`: Lists all dependencies for the current working directory.
  ```sh
  alias ylc="yarn list"
  ```

- `yga`: Adds a global Yarn package.
  ```sh
  alias yga="yarn global add"
  ```

- `ygl`: Lists global Yarn packages.
  ```sh
  alias ygl="yarn global list"
  ```

- `rny`: Removes node_modules and installs Yarn packages.
  ```sh
  alias rny="rm -rf node_modules && yarn install"
  ```

- `rnly`: Removes yarn.lock and node_modules, then installs Yarn packages.
  ```sh
  alias rnly="rm -rf yarn.lock && rm -rf node_modules && yarn install"
  ```

- `yl`: Runs Yarn lint script.
  ```sh
  alias yl="yarn lint"
  ```

- `yb`: Runs Yarn build script.
  ```sh
  alias yb="yarn build"
  ```

- `ya`: Adds a Yarn package.
  ```sh
  alias ya="yarn add"
  ```

- `yad`: Adds a Yarn devDependency package.
  ```sh
  alias yad="yarn add -D"
  ```

- `yae`: Adds a Yarn package with exact version.
  ```sh
  alias yae="yarn add -E"
  ```

- `yade`: Adds a Yarn devDependency package with exact version.
  ```sh
  alias yade="yarn add -D -E"
  ```

- `yrm`: Removes a Yarn package.
  ```sh
  alias yrm="yarn remove"
  ```

## Miscellaneous

- `ep`: Echoes the PATH environment variable.
  ```sh
  alias ep='echo $PATH'
  ```

- `qt`: Generates TypeScript types from a JSON file.
  ```sh
  function qt {
    if [ ! -n "$1" ]; then
      echo "Enter JSON file to generate Typescript file"
    else
      quicktype "$1" -o ${1%.json}.ts --just-types
    fi
  }
  ```

- `lpi`: Logs version and path including symbolic links for a package/program.
  ```sh
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
  ```

- `cpy`: Copies argument output without the last trailing newline.
  ```sh
  function cpy {
    if [ ! -n "$1" ]; then
      echo "Enter something to copy without newlines"
    else
      echo -n "$($@)" | pbcopy
    fi
  }
  ```

- `cpyf`: Copies argument output formatted without any ANSI escape characters.
  ```sh
  function cpyf {
    if [ ! -n "$1" ]; then
      echo "Enter something to copy without ANSI escape characters";
    else
      echo -n "$($@)" | ansifilter | col -b -x | pbcopy;
    fi
  }
  ```

- `cpyp`: Copies the current path.
  ```sh
  alias cpyp="cpy pwd"
  ```

- `st`: Opens SourceTree in the current folder.
  ```sh
  alias st='open -a SourceTree'
  ```

- `jus`: Updates Jest snapshots.
  ```sh
  alias jus="jest --updateSnapshot"
  ```

- `c`: Opens VS Code in the current folder.
  ```sh
  alias c="code ."
  ```

## Hardhat

- `nhc`: Compiles Hardhat contracts.
  ```sh
  alias nhc='npx hardhat compile'
  ```

- `nht`: Runs Hardhat tests.
  ```sh
  alias nht='npx hardhat test'
  ```

## Brew

- `bout`: Lists outdated Brew packages.
  ```sh
  alias bout="brew outdated"
  ```