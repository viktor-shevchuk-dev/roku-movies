function handleBackButtonClickFromMovieListScreen()
  previousScreenId = m.screensHistory.pop().screenId
  if previousScreenId = "searchForMoviesScreen"
    return showScreen({ screenId: m.searchForMoviesScreen.id })
  else if previousScreenId = "headerScreen"
    return showScreen({ screenId: m.headerScreen.id })
  end if
end function

function handleBackButtonClickFromDetailsScreen()
  previousScreen = m.screensHistory.pop()
  previousScreenId = previousScreen.screenId
  previousScreenContent = previousScreen.content

  if previousScreenId = "personScreen"
    return showScreen({ screenId: m.personScreen.id, addContentIfPresent: true, content: previousScreenContent })
  else if previousScreenId = "movieListScreen"
    return showScreen({ screenId: m.movieListScreen.id })
  else if previousScreenId = "castScreen"
    return showScreen({ screenId: m.castScreen.id })
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
    previousScreen = m.screensHistory.pop()
    previousScreenId = previousScreen.screenId
    previousScreenContent = previousScreen.content

    return showScreen({ screenId: previousScreenId, addContentIfPresent: true, content: previousScreenContent })
  else if m.reviewsScreen.visible
    return showScreen({ screenId: m.screensHistory.pop().screenId, addContentIfPresent: true })
  else if m.personScreen.visible
    return showScreen({ screenId: m.screensHistory.pop().screenId, addContentIfPresent: true })
  end if

  return false
end function