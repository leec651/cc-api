# setup env
- node: js runtime environment
- npm: node package management
- nodemon: automatically restarting the node application when file changes in the directory are detected
- coffeescript@2: coffeescript v2 added some ES6 support.
```shell
brew install node
brew install npm
npm install -g coffeescript@2
npm install nodemon
```

# setup & start db
For simplicity, let's provide a paht to your db.
```shell
brew install mongodb
mkdir /Users/[chen]/data/db
mongod --dbpath /Users/[chen]/data/db
```

# setup & start express server
dev is an alias to "nodemon server.coffee"
```shell
cd ./cc-api
npm install
npm run dev
```

# populate test data
Generate some test data.
```shell
npm run data
```
