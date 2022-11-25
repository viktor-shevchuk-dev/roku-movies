sub specificGenreMovieClickHandler(obj)
  contextScreen = obj.getRoSGNode()
  topRatedMoviesList = contextScreen.findNode ("topRatedMoviesList")
  m.selectedMovie = getMovieFromRowListByEvent(topRatedMoviesList, "click")
  content = { title: m.selectedMovie.title,
    description: m.selectedMovie.additionalInformation.description,
  id: m.selectedMovie.id, posterUrl: generateImageUrl(m.selectedMovie.additionalInformation.posterUrl, "300") }
  m.detailsScreen.content = content
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub