# push to master branch
git add -u .
git add .

read -p 'Enter a commit message: ' msg
git commit -m "$msg"

git push -u origin master

