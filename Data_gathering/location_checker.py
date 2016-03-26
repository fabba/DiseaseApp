from geopy.geocoders import Nominatim
import MySQLdb, geopy, time

db = MySQLdb.connect(host="mysql814.cp.hostnet.nl",port=3306,user="u236248_emiela",passwd="runescape",db="db236248_diseases",charset='utf8')
cursor = db.cursor()
geolocator = Nominatim()

query = 'SELECT tweetID, user_location FROM tweets'
cursor.execute(query)
tweets = cursor.fetchall()

start_time = time.time()
count = 0
for tweet in tweets[3100:]:
    if tweet[1] != 'None':
        try: 
            location = geolocator.geocode(tweet[1],language='en')
        except geopy.exc.GeocoderServiceError:
            print 'Made too many API calls. Pausing for 10 seconds.'
            time.sleep(10)
            location = 'None'
        country = unicode(location).split(',')[-1]
        try: query = u'UPDATE tweets SET user_location = \'{0}\' WHERE tweetID = {1}'.format(country,tweet[0])
        except Exception: query = 'UPDATE tweets SET user_location = \'None\' WHERE tweetID = {0}'.format(tweet[0])
        try:
            cursor.execute(query)
            db.commit()
            count += 1
            if count % 10 == 0:
                print str(count) + ' tweets have a correct location now. Total time spent: ' + str(round(time.time() - start_time,1)) + ' seconds'
        except Exception:
            print 'This query gave an error.'
                
query = 'SELECT tweetID, coordinates FROM tweets WHERE coordinates != \'None\''
cursor.execute(query)
tweets = cursor.fetchall()
for tweet in tweets:
    coordinates = tweet[1].strip('[]')
    try: 
        location = geolocator.geocode(tweet[1],language='en')
    except geopy.exc.GeocoderServiceError:
        print 'Made too many API calls. Pausing for 10 seconds.'
        time.sleep(10)
        location = 'None'
    try: country = unicode(location).split(',')[-1]
    except TypeError: country = 'None'
    try: query = u'UPDATE tweets SET user_location = \'{0}\' WHERE tweetID = {1}'.format(country,tweet[0])
    except Exception: query = 'UPDATE tweets SET user_location = \'None\' WHERE tweetID = {0}'.format(tweet[0])
    try:
        cursor.execute(query)
        db.commit()
        count += 1
        if count % 50 == 0:
            print str(count) + ' tweets have a correct location now. Total time spent: ' + str(round(time.time() - start_time,1)) + ' seconds'
    except Exception:
        print 'This query gave an error: ' + str(query)