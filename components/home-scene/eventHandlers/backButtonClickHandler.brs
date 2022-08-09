function handleBackButtonClickFromMovieListScreen(screenToGoId, screenToGoContent)
  if screenToGoId = "searchForMoviesScreen"
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  else if screenToGoId = "headerScreen"
    return showScreen({ screenId: screenToGoId })
  end if
end function

function handleBackButtonClickFromDetailsScreen(screenToGoId, screenToGoContent)
  if screenToGoId = "personScreen"
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  else if screenToGoId = "movieListScreen"
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  else if screenToGoId = "peopleScreen"
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  end if
end function

function handleBackButtonClickFromVideoPlayer(screenToGoId, screenToGoContent)
  stopVideo()
  return showScreen({ screenId: screenToGoId, content: screenToGoContent })
end function

function handleBackButtonClick()
  screenToGo = m.screensHistory.pop()
  screenToGoId = screenToGo.screenId
  screenToGoContent = screenToGo.content

  if m.movieListScreen.visible
    return handleBackButtonClickFromMovieListScreen(screenToGoId, screenToGoContent)
  else if m.searchForMoviesScreen.visible
    return showScreen({ screenId: screenToGoId })
  else if m.detailsScreen.visible
    return handleBackButtonClickFromDetailsScreen(screenToGoId, screenToGoContent)
  else if m.videoPlayer.visible
    return handleBackButtonClickFromVideoPlayer(screenToGoId, screenToGoContent)
  else if m.peopleScreen.visible
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  else if m.reviewsScreen.visible
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  else if m.personScreen.visible
    return showScreen({ screenId: screenToGoId, content: screenToGoContent })
  end if

  return false
end function