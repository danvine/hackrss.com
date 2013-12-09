HackRSS
============

Heroku Startup Instructions
---------------------------

	git clone https://github.com/danvine/hackrss.git
	cd hackrss
	heroku create hackrss
	git push heroku master
	heroku addons:add memcachier
	heroku config:set URL2PNG_APIKEY=$URL2PNG_APIKEY
	heroku config:set URL2PNG_SECRET=$URL2PNG_SECRET
	heroku open

