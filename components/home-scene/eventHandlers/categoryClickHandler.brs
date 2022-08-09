sub categoryClickHandler(obj)
  list = m.headerScreen.findNode("headerList")
  index = obj.getData()[1]
  category = list.content.getChild(0).getChild(index)
  urlToMakeQuery = category.urlToMakeQuery

  if urlToMakeQuery = ""
    showNewScreenWithSavingCurrent(category.id)
  else if category.id = m.movieListScreen.id
    showTrendingThisWeek(urlToMakeQuery)
  else if category.id = m.peopleScreen.id
    showPopularActorsList(urlToMakeQuery)
  end if
end sub