# posts server (callled sequences for reasons)

It's a project, not a library.

Clone the whole repo (pswsm-repo) as of now, I'll try to change it in the near future.

Required env variables to run:
- INFRA_TARGET : The infrastructure target. Currently only suports CouchDB.
- COUCHDB_URI : The couchdb link
- COUCHDB_USERNAME : Teh CouchDB auth username
- COUCHDB_PASSWORD : CouchDB auth pasword

Optional variables:
- PORT : Defaults to `3000`
- LOG_LEVEL : Defaults to `info`. [`debug`, `info`, `warning`, `error`]
