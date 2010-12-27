# Google Hot Trends : API

## Simple API with save in database and cache

###Format : 
- by day : {domain}/api/hottrends/:date.:format format => (html, xml, json, text)
- by date interval : {domain}/api/hottrends/:start_date/:end_date.:format
- with limit : {domain}/api/hottrends/:start_date/:end_date/:limit.:format limit => (1..20)

##### [*Exemple : http://hottrends.heroku.com/api/hottrends/2010-12-23.xml *](http://hottrends.heroku.com/api/hottrends/2010-12-23.xml/)
##### [*Exemple : http://hottrends.heroku.com/api/hottrends/2010-12-23/2010-12-25.xml *](http://hottrends.heroku.com/api/hottrends/2010-12-23/2010-12-25.xml/)
##### [*Exemple : http://hottrends.heroku.com/api/hottrends/2010-12-23/2010-12-25/5.xml *](http://hottrends.heroku.com/api/hottrends/2010-12-23/2010-12-25/5.xml/)

by [Sebastien Bourdu aka ekkans](http://sebastienbourdu.com/).