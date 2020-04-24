from flask import Flask
from flask import jsonify
import json
import feedparser

feeds = ['https://blog.ycombinator.com/feed/', 
         'http://www.espncricinfo.com/rss/content/story/feeds/blogs.rss']

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"
	
@app.route("/all-news")
def getAllNewsSummary():
   allNews = json.loads(open('news.json').read())
   print allNews['newsItems'][0]
   return jsonify(allNews)

@app.route("/get-feeds")   
def readFeed():
   # for feedUrl in feeds:
   #    print feedUrl
   #    feed = feedparser.parse(feedUrl)
   #    print 'len(feed.entries)', len(feed.entries)
   #    for entry in feed.entries:
   #       print entry
   feed = feedparser.parse(feeds[1])
   print 'len(feed.entries)', len(feed.entries)
   i = 0
   entryData=[]
   for entry in feed.entries:
      entryData.append({'id': str(i), 
      'title': entry.title, 
      'desc': entry.summary, 
      'srcUrl': entry.link, 
      'imageUrl':feed.feed.image.href,
      'pubDate':entry.published})
      i=i+1
   allItems = {'newsItems': entryData}
   # return json.dumps(entryData, skipkeys=True)
   return jsonify(allItems)

if __name__ == "__main__":
    app.run()