process.env.CREATE_INDEXES = true

{Person, Contract} = require './'

console.log "Sent command to build indexes, check mongo's currentOps to status"
