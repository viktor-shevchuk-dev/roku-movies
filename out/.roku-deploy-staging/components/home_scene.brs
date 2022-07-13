sub showScreen(screenId)
  m.headerScreen.visible = false
  m.top.focusedChild.visible = false
  screenToShow = m.top.findNode(screenId)
  screenToShow.visible = true
end sub

sub onAsyncTaskResponse(obj)
  response = obj.getData()
  data = ParseJson(response)
  if data <> invalid and data.results <> invalid
    showScreen(m.movieListScreen.id)
    m.movieListScreen.data = data
  else
    ? "RESPONSE IS EMPTY"
  end if
end sub

sub loadUrl(url)
  m.asyncTask = createObject("roSGNode", "LoadAsyncTask")
  m.asyncTask.observeField("response", "onAsyncTaskResponse")
  m.asyncTask.url = url
  m.asyncTask.control = "RUN"
end sub

sub onCategorySelected(obj)
  list = m.headerScreen.findNode("headerList")
  index = obj.getData()
  category = list.content.getChild(index)
  if category.urlToMakeQuery = ""
    showScreen(category.id)
  else
    m.movieListScreen.title = "Trending This Week"
    loadUrl(category.urlToMakeQuery)
  end if
end sub

sub onSearchButtonClicked()
  searchQuery = m.searchForMoviesScreen.searchQuery
  m.movieListScreen.title = "Searched for " + searchQuery
  loadUrl("https://api.themoviedb.org/3/search/movie?api_key=04333487fae6801ae7461c72fe9ea316&language=en-US&page=1&include_adult=false&query=" + searchQuery)
end sub

sub onContentSelected(obj)
  selectedIndex = obj.getData()
  m.selectedMedia = m.movieListScreen.findNode("homeGrid").content.getChild(selectedIndex)
  m.detailsScreen.content = m.selectedMedia
  m.movieListScreen.visible = false
  m.detailsScreen.visible = true
end sub

sub onPlayButtonPressed(obj)
  switchScreens(m.detailsScreen, m.videoPlayer)
  m.videoPlayer.content = m.selectedMedia
  m.videoPlayer.control = "play"
end sub

sub onPlayerPositionChanged(obj)
  ? "Player Position: ", obj.getData()
end sub

sub stopVideo()
  m.videoPlayer.control = "stop"
end sub

sub onPlayerStateChanged(obj)
  state = obj.getData()
  ? "onPlayerStateChanged: ";state
  if state = "error"
    ? "Error Message: ";m.videoplayer.errorMsg
    ? "Error Code: ";m.videoplayer.errorCode
  else if state = "finished"
    stopVideo()
    switchScreens(m.videoPlayer, m.detailsScreen)
  end if
end sub

sub initializeVideoPlayer()
  m.videoPlayer.EnableCookies()
  m.videoPlayer.setCertificatesFile("common:/certs/ca-bundle.crt")
  m.videoPlayer.InitClientCertificates()
  m.videoPlayer.notificationInterval = 10
  m.videoPlayer.observeFieldScoped("position", "onPlayerPositionChanged")
  m.videoPlayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

function init()
  ? "[home_scene] init"
  m.headerScreen = m.top.findNode("headerScreen")
  m.movieListScreen = m.top.findNode("movieListScreen")
  m.searchForMoviesScreen = m.top.findNode("searchForMoviesScreen")
  m.detailsScreen = m.top.findNode("detailsScreen")

  m.videoPlayer = m.top.findNode("videoPlayer")
  initializeVideoPlayer()

  m.headerScreen.observeField("pageSelected", "onCategorySelected")
  m.searchForMoviesScreen.observeField("searchButtonClicked", "onSearchButtonClicked")
  m.movieListScreen.observeField("contentSelected", "onContentSelected")
  m.detailsScreen.observeField("playButtonPressed", "onPlayButtonPressed")

  m.headerScreen.setFocus(true)
end function

function switchScreens(screenToHide, screenToShow)
  screenToHide.visible = false
  screenToShow.visible = true
  screenToShow.setFocus(true)

  return true
end function

function handleBackButtonClickFromMovieListScreen()
  isSearchForMoviesTitle = Mid(m.movieListScreen.title, 1, 12) = "Searched for"
  isTrendingThisWeekTitle = m.movieListScreen.title = "Trending This Week"
  if isSearchForMoviesTitle
    return switchScreens(m.movieListScreen, m.searchForMoviesScreen)
  else if isTrendingThisWeekTitle
    return switchScreens(m.movieListScreen, m.headerScreen)
  end if
end function

function handleBackButtonClick()
  if m.movieListScreen.visible
    return handleBackButtonClickFromMovieListScreen()
  else if m.searchForMoviesScreen.visible
    return switchScreens(m.searchForMoviesScreen, m.headerScreen)
  else if m.detailsScreen.visible
    return switchScreens(m.detailsScreen, m.movieListScreen)
  else if m.videoPlayer.visible
    stopVideo()
    return switchScreens(m.videoPlayer, m.detailsScreen)
  end if

  return false
end function

function onKeyEvent(key, press) as boolean
  ? "[home_scene] onKeyEvent", key, press
  if key = "back" and press
    return handleBackButtonClick()
  end if

  return false
end function