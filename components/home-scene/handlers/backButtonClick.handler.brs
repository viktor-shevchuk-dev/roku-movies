function handleBackButtonClickFromMovieListScreen()
  screenToGo = m.screensHistory.pop()
  screenToGoId = screenToGo.screenId
  screenToGoContent = screenToGo.content

  if screenToGoId = "searchForMoviesScreen"
    return showScreen({ screenId: m.searchForMoviesScreen.id, content: screenToGoContent })
  else if screenToGoId = "headerScreen"
    return showScreen({ screenId: m.headerScreen.id })
  end if
end function

function handleBackButtonClickFromDetailsScreen()
  screenToGo = m.screensHistory.pop()
  screenToGoId = screenToGo.screenId
  screenToGoContent = screenToGo.content

  if screenToGoId = "personScreen"
    return showScreen({ screenId: m.personScreen.id, addContentIfPresent: true, content: screenToGoContent })
  else if screenToGoId = "movieListScreen"
    return showScreen({ screenId: m.movieListScreen.id, addContentIfPresent: true, content: screenToGoContent })
  else if screenToGoId = "castScreen"
    return showScreen({ screenId: m.castScreen.id, addContentIfPresent: true, content: screenToGoContent })
  end if
end function

function handleBackButtonClick()
  if m.movieListScreen.visible
    return handleBackButtonClickFromMovieListScreen()
  else if m.searchForMoviesScreen.visible
    return showScreen({ screenId: m.screensHistory.pop().screenId })
  else if m.detailsScreen.visible
    return handleBackButtonClickFromDetailsScreen()
  else if m.videoPlayer.visible
    stopVideo()
    return showScreen({ screenId: m.screensHistory.pop().screenId })
  else if m.castScreen.visible
    screenToGo = m.screensHistory.pop()
    screenToGoId = screenToGo.screenId
    screenToGoContent = screenToGo.content

    return showScreen({ screenId: screenToGoId, addContentIfPresent: true, content: screenToGoContent })
  else if m.reviewsScreen.visible
    screenToGo = m.screensHistory.pop()
    screenToGoId = screenToGo.screenId
    screenToGoContent = screenToGo.content

    return showScreen({ screenId: screenToGoId, addContentIfPresent: true, content: screenToGoContent })
  else if m.personScreen.visible
    screenToGo = m.screensHistory.pop()
    screenToGoId = screenToGo.screenId
    screenToGoContent = screenToGo.content

    return showScreen({ screenId: screenToGoId, addContentIfPresent: true, content: screenToGoContent })
  end if

  return false
end function