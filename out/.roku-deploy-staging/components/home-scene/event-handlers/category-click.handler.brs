sub categoryClickHandler(obj)
  list = m.homeScreen.findNode("headerList")
  index = obj.getData()[1]
  m.category = list.content.getChild(0).getChild(index)
  urlToMakeQuery = m.category.urlToMakeQuery
  id = m.category.id

  if id = m.movieListScreen.id
    showTrendingThisWeek(urlToMakeQuery)
  else if id = m.peopleScreen.id
STOP
    showPopularActorsList(urlToMakeQuery)
  end if
end sub