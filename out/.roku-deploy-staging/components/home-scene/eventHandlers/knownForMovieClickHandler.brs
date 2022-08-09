sub knownForMovieClickHandler(obj)
  selectedKnownForMovieIndex = obj.getData()[1]
  selectedKnownForMovie = m.personScreen.findNode("knownForList").content.getChild(0).getChild(selectedKnownForMovieIndex)
  m.detailsScreen.content = getContentForMovieDetailsScreen(selectedKnownForMovie)
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub