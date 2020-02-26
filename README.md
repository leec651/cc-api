# setup env
- brew install node
- brew install npm
- npm install -g coffeescript@2
- npm install nodemon

# setup & start db
- brew install mongodb
- mkdir /Users/[chen]/data/db
- mongod --dbpath /Users/[chen]/data/db

# setup & start express server
- cd ./cc-api
- npm install
- nodemon server.coffee
