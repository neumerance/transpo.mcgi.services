git fetch
git checkout master
git reset --hard origin/master

docker compose -f docker-compose.prod.yml up --build -d

