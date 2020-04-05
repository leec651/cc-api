
QUOTES =
  inspire: 'Inspiring Quote of the day'
  management: 'Management Quote of the day'
  sports: 'Sports Quote of the day'
  life: 'Quote of the day about life'
  funny: 'Funny Quote of the day'
  love: 'Quote of the day about Love'
  art: 'Art quote of the day'
  students: 'Quote of the day for students'

module.exports = (app) ->

  app.get '/quote', (req, res) ->
    {category} = req.query
    data =
      quotes: [{
        text: QUOTES[category] || 'Life is either a daring adventure or nothing'
        author: 'Helen Keller'
        background: 'https://theysaidso.com/img/qod/qod-inspire.jpg'
        category
      }]
    res.json data

  app.get '/category', (req, res) ->
    res.json { categories: QUOTES }
