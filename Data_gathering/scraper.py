import twitter, MySQLdb, time

CONSUMER_KEY = 'aEAhc9IRdDHnkOJOmHLVoHXaQ'
CONSUMER_SECRET = '3431lXK2rQAbGu3mde4I5VPgRdHR6DQ395yD5AJHKzDYuSQ8ef'
OAUTH_TOKEN = '532301436-LHY5544hpAqEaBZSuTKvZYAphhhi44QCGhqxc6tt' 
OAUTH_TOKEN_SECRET = 'pmNs6EmzoUmZP9FPZLG2lsH9rBGYl7cAb3Sp4OnR8op4L'
auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,CONSUMER_KEY, CONSUMER_SECRET)
twitter_api = twitter.Twitter(auth=auth)
db = MySQLdb.connect(host="mysql814.cp.hostnet.nl",port=3306,user="u236248_emiela",passwd="runescape",db="db236248_diseases",charset='utf8')
cursor = db.cursor()

def get_diseases_from_file(path):
    final_list = []
    with open(path,'rb') as diseases:
        diseases_list = diseases.read().split('\n')
        for line in diseases_list[2:]:
            name = line.split(',')[0].strip('\"')
    
            if '(' in line:
                second_name = name.split('(')[-1].strip(')')
                name = name.split('(')[0]
                
                if ';' in second_name:
                    third_name = second_name.split(';')[-1]
                    second_name = second_name.split(';')[0]
                    
                    final_list.extend([name, second_name, third_name])
                
                else:
                    final_list.extend([name, second_name])
    
            else:
                final_list.append(name)
    
    return final_list

''' Start Program '''

disease_list = get_diseases_from_file('data.txt') # The input file contains all infectious diseases
count = 0
user_list = ''

for disease in disease_list:
    ''' Finds all recent tweets that are about each disease '''
    q = disease
    try: results = twitter_api.search.tweets(q=q, count = 0)
    except twitter.api.TwitterHTTPError: 
        print 'Rate limit exceeded. Pausing for 15 minutes.'
        time.sleep(900)
        
        
    tweets = results['statuses']
    
    for tweet in tweets:
        ''' Fetches the data of each tweet '''
        tweet_id = tweet['id']
        user_id = tweet['user']['id']
        text = tweet['text'].replace('\'','')
        print text
        try: coordinates = tweet['coordinates']['coordinates']
        except Exception: coordinates = tweet['coordinates']
        
        user_list += str(user_id) + ','

        ''' Adds the tweet to the database '''
        try: query = u'INSERT IGNORE INTO tweets (disease, tweetID, userID, text, coordinates) VALUES (\'{0}\',{1}, {2}, \'{3}\', \'{4}\')'.format(disease,tweet_id,user_id,text,coordinates)                                                           
        except Exception: 'Got an encoding error on a query.'
            
        try: 
            cursor.execute(query)
            db.commit()
            count += 1
            
        except Exception:
            print 'This query returned an error: ' + query

        if count % 25 == 0:
            print str(count) + ' tweets added to the database.'
            
        if count % 50 == 0:
            ''' Find the location of the users that made the tweets '''
            
            try: user_result = twitter_api.users.lookup(user_id=user_list[:-1])
            except twitter.api.TwitterHTTPError: 
                print 'Rate limit exceeded. Pausing for 15 minutes.'
                time.sleep(900)
                
            for user_data in user_result:
                try: user_location = user_data['location'].replace('\'','')
                except AttributeError: user_location = user_data['location']
                if len(user_location) == 0:
                    user_location = None
                username = user_data['name'].replace('\'','')
                query = u'UPDATE tweets SET user_location = \'{0}\', userName = \'{1}\' WHERE userID = {2}'.format(user_location,username,user_data['id'])
                try: 
                    cursor.execute(query)
                    db.commit()
                    
                except Exception:
                    print 'This query returned an error: ' + query
                
            print 'Added the user data of ' + str(len(user_list[:-1].split(','))) + ' tweets.'
            user_list = ''

        
db.close()