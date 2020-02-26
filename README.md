# setup env
- node: js runtime env
- npm: Node package management
- nodemon: Automatically restart the node application when file changes are detected.
- coffeescript@2: CoffeeScript is a little language that compiles into JavaScript. ES6 features were added to v2.
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
