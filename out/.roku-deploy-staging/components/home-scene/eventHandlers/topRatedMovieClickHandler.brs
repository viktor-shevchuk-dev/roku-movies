sub topRatedMovieClickHandler(obj)
  contextScreen = obj.getRoSGNode()
  topRatedMoviesList = contextScreen.findNode ("topRatedMoviesList")
  selectedTopRatedMovie = getMovieFromRowListByEvent(topRatedMoviesList, "click")
  content = { title: selectedTopRatedMovie.title,
    description: selectedTopRatedMovie.additionalInformation.description,
  id: selectedTopRatedMovie.id, posterUrl: generateImageUrl(selectedTopRatedMovie.additionalInformation.posterUrl, "300") }
  m.detailsScreen.content = content
  showNewScreenWithSavingCurrent(m.detailsScreen.id)
end sub