Q = require 'bluebird'
Q.promisifyAll(require('redis'))
os = require 'os'
global.xlenv = require "xtralife-env"

global.logger = require 'winston'
global.logger.level = "error"

xlenv.override null,
	nbworkers: 1

	privateKey: "CONFIGURE : This is a private key and you should customize it"

	logs:
		slack:
			enable: false

	redis:
		host: "localhost"
		port: 6378

	redisClient: (cb)->
		client = require('redis').createClient(xlenv.redis.port, xlenv.redis.host)
		client.info (err)->
			cb err, client

	redisChannel: (cb)->
		client = require('redis').createClient(xlenv.redis.port, xlenv.redis.host)
		client.info (err)->
			cb err, client

	redisStats: (cb)->
		client = require('redis').createClient(xlenv.redis.port, xlenv.redis.host)
		client.info (err)->
			client.select 10
			cb err, client

	mongodb:
		dbname: 'xtralife'

		url: "mongodb://localhost:27018"
		options: # see http://mongodb.github.io/node-mongodb-native/driver-articles/mongoclient.html
			db:
				w: 1
				readPreference: "primaryPreferred"

			server:
				auto_reconnect: true

			mongos: {}
			promiseLibrary: require 'bluebird'

	mongoCx: (cb)->
		require("mongodb").MongoClient.connect xlenv.mongodb.url, xlenv.mongodb.options, (err, mongodb)->
			return cb(err, mongodb)

	elastic: (cb)->
		elastic = require("elasticsearch")
		client = new elastic.Client()
		cb null, client

	options:
		notifyUserOnBrokerTimeout: true

		removeUser: true

		hookLog:
			enable: true
			limit: 5
		timers:
			enable: true
			listen: true

		hostnameBlacklist: ['localhost', '127.0.0.1']

	mailer: null # not used for xtralife-http tests

	http:
		waterline: 600 # warn if we serve more than 10 req/sec
		port : 1999 # allows running tests when a full server is running

	xtralife:
		games:
			"com.clanofthecloud.testgame": 
				apikey:"testgame-key"
				apisecret:"testgame-secret"
				config:
					enable:true
					domains:[]
					eventedDomains:[]
					certs:
						android:
							enable: false
							senderID: ''
							apikey: ''
						ios:
							enable: false
							cert: ''
							key: ''
						macos:
							enable: false
							cert: ''
							key: ''
					socialSettings:
						facebookAppToken : ''

			"com.clanofthecloud.cloudbuilder": 
				apikey:"cloudbuilder-key"
				apisecret:"azerty"
				config:
					enable:true
					domains:["com.clanofthecloud.cloudbuilder.m3Nsd85GNQd3","com.clanofthecloud.cloudbuilder.test"]
					eventedDomains:["com.clanofthecloud.cloudbuilder.m3Nsd85GNQd3"]
					certs:
						android:
							enable: false
							senderID: ''
							apikey: ''
						ios:
							enable: false
							cert: ''
							key: ''
						macos:
							enable: false
							cert: ''
							key: ''
					socialSettings:
						facebookAppToken : ''

	AWS: # to run the xtralife-http tests, you MUST configure access to an S3 bucket
		S3:
			bucket: 'CONFIGURE'
			credentials:
				region: 'CONFIGURE'
				accessKeyId: 'CONFIGURE'
				secretAccessKey: 'CONFIGURE'

	hooks:
		recursionLimit: 5
		definitions:
			"com.clanofthecloud.cloudbuilder.azerty": # needed for unit tests
				'__doesntcompile': "return bigbadbug["
		functions: require './batches.js'
