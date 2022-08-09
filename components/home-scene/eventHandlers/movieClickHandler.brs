sub movieClickHandler(obj)
  selectedIndex = obj.getData()
  m.selectedMovie = m.movieListScreen.findNode("homeGrid").content.getChild(selectedIndex)
  m.detailsScreen.content = getContentForMovieDetailsScreen(m.selectedMovie)
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub