#
# git
#

# Stolen from: https://stackoverflow.com/a/42544963
git-largest-objects() {
  git rev-list --objects --all |
    git cat-file \
      --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
    sed -n 's/^blob //p' |
    sort --numeric-sort --key=2 |
    cut -c 1-12,41- |
    $(command-path gnumfmt || echo numfmt) \
      --field=2 \
      --to=iec-i \
      --suffix=B \
      --padding=7 \
      --round=nearest
}

if command-exists delta; then
  setup-completions delta "$(mise-which delta)" delta completions zsh
elif command-exists difft; then
  export GIT_EXTERNAL_DIFF=difft
fi
