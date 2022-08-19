sub movieClickHandler(obj)
  contextScreen = obj.getRoSGNode()
  selectedIndex = obj.getData()
  m.selectedMovie = contextScreen.findNode("homeGrid").content.getChild(selectedIndex)
  content = { title: m.selectedMovie.SHORTDESCRIPTIONLINE1,
    description: m.selectedMovie.SHORTDESCRIPTIONLINE2,
  id: m.selectedMovie.id, posterUrl: m.selectedMovie.HDGRIDPOSTERURL }
  m.detailsScreen.content = content
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub