# Daily Git Commands 

## Git branch

 * `git checkout -b feature1` (create a new branch, called "feature1").
 * `git checkout master` (switch back to master branch).
 * `git pull origin master` (pull changes from master, optional).
 * `git merge feature1` (merged "feature1" branch back to master branch).
 * `git branch -d feature1` (delete the local branch after merge, optional).
 * `git push origin master` (push changes to remote master, optional).

## Git log 

* ` git log --oneline` condenses each commit to a single line
* `git log --oneline --decorate` display all of the references (e.g., branches, tags, etc) that point to each commit
* `git log -p` changes introduced by each commit
* `git log --stat` displays the number of insertions and deletions to each file altered by each commit  
* `git shortlog` groups each commit by author and displays the first line of each commit message
* `git log --graph --oneline --decorate` draws an ASCII graph representing the branch structure of the commit history
* `git log --pretty=format:"%cn committed %h on %cd"` all placeholders in [pretty formats](https://www.kernel.org/pub/software/scm/git/docs/git-log.html#_pretty_formats), eg. `git log --graph --all --pretty=format:'%C(yellow)%h -%C(auto)%d %C(bold cyan)%s %C(bold white)(%cr)%Creset %C(dim white)<%an>' ` .
* `git log  -3`  filter by amount
* `git log --after='2020-3-20' --before='2020-3-25'` , `git log  --after="yesterday"` by date
* `git log --author='Hantsy'`, `git log --author='Hantsy\|Tom'` by author
* `git log --grep "docker"`  filter by message.
* `git log -- README.md` filter by file, `--` parameter is used to tell git log that subsequent arguments are file paths and not branch names.
* `git log -S"MSSQL"` filter by  file content.
* `git log <since>..<until>` where `<since>` and `<until>` are commit references, eg. `git log master..feature`
* `git log --no-merges` and `git log --merges` excludes merges commits or only includes merge commits.
