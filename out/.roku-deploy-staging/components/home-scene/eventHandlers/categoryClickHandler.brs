sub categoryClickHandler(obj)
  list = m.homeScreen.findNode("headerList")
  index = obj.getData()[1]
  m.category = list.content.getChild(0).getChild(index)
  urlToMakeQuery = m.category.urlToMakeQuery

  if urlToMakeQuery = ""
    showNewScreenWithSavingCurrent(m.category.id)
  else if m.category.id = m.movieListScreen.id
    showTrendingThisWeek(urlToMakeQuery)
  else if m.category.id = m.peopleScreen.id
    showPopularActorsList(urlToMakeQuery)
  end if
end sub