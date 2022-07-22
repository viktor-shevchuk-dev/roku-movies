sub showScreen(screenId)
  m.headerScreen.visible = false
  m.top.focusedChild.visible = false
  screenToShow = m.top.findNode(screenId)
  screenToShow.visible = true
end sub

function handleReceivedMovies(movies)
  showScreen(m.movieListScreen.id)
  m.movieListScreen.data = movies
end function

function handleReceivedConfig(config)
  m.APIKey = config.APIKey
  m.baseUrl = config.baseUrl
  params = { config: config }
  m.headerScreen.callFunc("setHeaderListContent", params)
  m.movieListScreen.callFunc("updateDummyVideos", params)
end function

function handleMovieDetails(movieDetails)
  m.detailsScreen.movieDetails = movieDetails
end function

sub onAsyncTaskResponse(obj)
  response = obj.getData()
  data = ParseJson(response)
  if data = invalid
    showErrorDialog("Response is malformed.")
    return
  end if

  if data.results <> invalid
    handleReceivedMovies(data)
  else if data.categories <> invalid
    handleReceivedConfig(data)
  else if data.genres <> invalid
    handleMovieDetails(data)
  end if
end sub

sub onLoadingUrlError(obj)
  showErrorDialog(obj.getData())
end sub

sub loadUrl(url)
  m.asyncTask = createObject("roSGNode", "LoadAsyncTask")
  m.asyncTask.observeField("error", "onLoadingUrlError")
  m.asyncTask.observeField("response", "onAsyncTaskResponse")
  m.asyncTask.url = url
  m.asyncTask.control = "RUN"
end sub

sub onCategorySelected(obj)
  list = m.headerScreen.findNode("headerList")
  index = obj.getData()[1]
  category = list.content.getChild(0).getChild(index)

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
  url = m.baseUrl + "/search/movie" + m.APIKey + "&language=en-US&page=1&include_adult=false&query=" + searchQuery
  loadUrl(url)
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
    showErrorDialog(m.videoPlayer.errorMsg + chr(10) + "Error Code: " + m.videoPlayer.errorCode.toStr())
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

sub showErrorDialog(message)
  m.errorDialog.title = "ERROR"
  m.errorDialog.message = message
  m.errorDialog.visible = true
  m.top.dialog = m.errorDialog
end sub

sub fetchMovieDetails (obj)
  movieId = obj.getData()
  genresUrl = m.baseUrl + "/movie/" + movieId.toStr() + m.APIKey + "&language=en-US"

  loadUrl(genresUrl)
end sub

function init()
  ? "[home_scene] init"
  m.headerScreen = m.top.findNode("headerScreen")
  m.movieListScreen = m.top.findNode("movieListScreen")
  m.searchForMoviesScreen = m.top.findNode("searchForMoviesScreen")
  m.detailsScreen = m.top.findNode("detailsScreen")
  m.errorDialog = m.top.findNode("errorDialog")

  m.videoPlayer = m.top.findNode("videoPlayer")
  initializeVideoPlayer()

  m.headerScreen.observeField("pageSelected", "onCategorySelected")
  m.searchForMoviesScreen.observeField("searchButtonClicked", "onSearchButtonClicked")
  m.movieListScreen.observeField("contentSelected", "onContentSelected")
  m.detailsScreen.observeField("playButtonPressed", "onPlayButtonPressed")
  m.detailsScreen.observeField("fetchMovieDetails", "fetchMovieDetails")

  m.headerScreen.setFocus(true)
  configUrl = "https://run.mocky.io/v3/9268e1d3-ef80-423e-b143-c0bb13b7e340"
  loadUrl(configUrl)
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