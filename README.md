The app can be found live [here.](http://www.kabbagechallenge.herokuapp.com)

#### Using the App

The twitter search is a general search that returns the 15 most recent tweets relevant to
your search criteria.

The wikipedia search looks for an article with a title that matches your search criteria.

Say for example, you search for "election 2016". You will surely get results from Twitter,
but Wikipedia might not return anything. If you search for "barack obama" though, you'll get
the tweets about Barack Obama, and the first portion of the Wikipedia page on him.

#### Bottlenecks and Future Improvements

As far as performance bottlenecks go, there is only one instance of this app on heroku, so
to many users trying to hit it at once would slow things down eventually. A good solution
here would be moving the app to AWS where you could more easily spin up separate instances
of the application to handle the load.

Other potential issues, might be limits on API calls with Twitter or Wikipedia, but I'm not sure
this is something that could be fixed. A deeper dive into their documentation would most likely
answer this question.
