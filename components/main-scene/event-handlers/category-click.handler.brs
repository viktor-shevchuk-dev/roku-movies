sub categoryClickHandler(obj)
  list = m.homeScreen.findNode("headerList")
  index = obj.getData()[1]
  m.category = list.content.getChild(0).getChild(index)
  endpoint = m.category.endpoint
  url = getMovieDBUrl(endpoint)

  if m.global.movieDB.endpointsList.home.endpoint = endpoint
    showTrendingThisWeek(url)
  else if m.global.movieDB.endpointsList.popularActorsList.endpoint = endpoint
    showPopularActorsList(url)
  end if
end sub