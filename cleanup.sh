path=C_library/image-utils/spec
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=contrib/C/Cairo-1.12.16/spec
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=example/manage-mp3/.sconf_temp
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=example/manage-mp3/doc/descendant
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=library/base/doc/descendant
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=test/doc/descendant
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

path=tool/eiffel/doc/descendant
rm -r $path
git filter-branch --tree-filter 'rm -rf $path' --prune-empty HEAD

rm -Rf .git/logs .git/refs/original

git gc --prune=all --aggressive
