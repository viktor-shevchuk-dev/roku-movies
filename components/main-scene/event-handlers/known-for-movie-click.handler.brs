sub knownForMovieClickHandler(obj)
  selectedKnownForMovieIndex = obj.getData()[1]
  m.selectedMovie = m.personScreen.findNode("knownForList").content.getChild(0).getChild(selectedKnownForMovieIndex)
  content = { title: m.selectedMovie.SHORTDESCRIPTIONLINE1,
    description: m.selectedMovie.SHORTDESCRIPTIONLINE2,
  id: m.selectedMovie.id, posterUrl: m.selectedMovie.HDPOSTERURL }
  m.detailsScreen.content = content
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub