sub categoryClickHandler(obj)
  list = m.homeScreen.findNode("headerList")
  index = obj.getData()[1]
  m.category = list.content.getChild(0).getChild(index)
  endpoint = m.category.endpoint
  url = getMovieDBUrl(endpoint)

  if m.movieDB.home.endpoint = endpoint showTrendingThisWeek(url) else if m.movieDB.popularActorsList.endpoint = endpoint showPopularActorsList(url)
end sub