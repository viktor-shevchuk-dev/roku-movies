sub knownForMovieClickHandler(obj)
  selectedKnownForMovieIndex = obj.getData()[1]
  selectedKnownForMovie = m.personScreen.findNode("knownForList").content.getChild(0).getChild(selectedKnownForMovieIndex)
  content = { title: selectedKnownForMovie.SHORTDESCRIPTIONLINE1,
    description: selectedKnownForMovie.SHORTDESCRIPTIONLINE2,
  id: selectedKnownForMovie.id, posterUrl: selectedKnownForMovie.HDPOSTERURL }
  m.detailsScreen.content = content
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub