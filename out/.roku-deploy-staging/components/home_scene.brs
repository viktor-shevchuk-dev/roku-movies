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
  m.detailsScreen.callFunc("setDetailsContent", params)
  m.movieListScreen.callFunc("updateDummyVideos", params)
end function

function handleMovieDetails(movieDetails)
  m.detailsScreen.movieDetails = movieDetails
end function

function handleCast(cast)
  m.castScreen.title = "Cast of " + m.movieTitle
  showScreen(m.castScreen.id)
  m.castScreen.cast = cast
end function

function handleReviews(reviews)
  m.reviewsScreen.title = "Reviews of " + m.movieTitle
  showScreen(m.reviewsScreen.id)
  m.reviewsScreen.reviews = reviews
end function

sub handleKnownForMovies(movies)
  m.personScreen.knownForMovies = movies
end sub

sub handleMovies(movies)
  if m.personScreen.visible = true
    handleKnownForMovies(movies)
  else
    handleReceivedMovies(movies)
  end if
end sub

function handleResults(results)
  if results[0].title <> invalid
    handleMovies(results)
  else if results[0].author <> invalid
    handleReviews(results)
  end if
end function

sub handlePersonDetails(personDetails)
  m.personScreen.personDetails = personDetails
end sub

sub onAsyncTaskResponse(obj)
  response = obj.getData()
  data = ParseJson(response)
  if data = invalid
    showErrorDialog("Response is malformed.")
    return
  end if

  if data.results <> invalid
    handleResults(data.results)
  else if data.categories <> invalid
    handleReceivedConfig(data)
  else if data.genres <> invalid
    handleMovieDetails(data)
  else if data.cast <> invalid
    handleCast(data.cast)
  else if data.name <> invalid
    handlePersonDetails(data)
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

sub onAdditionalInformationSelected(obj)
  list = m.detailsScreen.findNode("additionalInformationList")
  index = obj.getData()[1]
  category = list.content.getChild(0).getChild(index)
  url = m.baseUrl + "/movie/" + m.movieId.toStr() + category.urlToMakeQuery + m.APIKey + "&language=en-US"
  loadUrl(url)
end sub

sub onSearchButtonClicked()
  searchQuery = m.searchForMoviesScreen.searchQuery
  m.movieListScreen.title = "Searched for " + searchQuery
  url = m.baseUrl + "/search/movie" + m.APIKey + "&language=en-US&page=1&include_adult=false&query=" + searchQuery
  loadUrl(url)
end sub

sub onPersonSelected(obj)
  selectedIndex = obj.getData()
  selectedPerson = m.castScreen.findNode("castGrid").content.getChild(selectedIndex)
  m.personScreen.content = selectedPerson
  m.castScreen.visible = false
  m.personScreen.visible = true
end sub

sub onMovieSelected(obj)
  selectedIndex = obj.getData()
  m.selectedMovie = m.movieListScreen.findNode("homeGrid").content.getChild(selectedIndex)
  m.detailsScreen.content = m.selectedMovie
  m.movieListScreen.visible = false
  m.detailsScreen.visible = true
end sub

sub onPlayButtonPressed(obj)
  switchScreens(m.detailsScreen, m.videoPlayer)
  m.videoPlayer.content = m.selectedMovie
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

sub setMovieTitle(obj)
  m.movieTitle = obj.getData()
end sub

sub fetchKnownFor(obj)
  personId = obj.getData()
  knownForUrl = m.baseUrl + "/discover/movie" + m.APIKey + "&language=en-US&sort_by=popularity.desc&include_adult=false&page=1&with_cast=" + personId.toStr()
  loadUrl(knownForUrl)
end sub

sub fetchPersonDetails(obj)
  personId = obj.getData()
  personUrl = m.baseUrl + "/person/" + personId.toStr() + m.APIKey + "&language=en-US"
  loadUrl(personUrl)
end sub

sub fetchMovieGenres(obj)
  m.movieId = obj.getData()
  genresUrl = m.baseUrl + "/movie/" + m.movieId.toStr() + m.APIKey + "&language=en-US"

  loadUrl(genresUrl)
end sub

function init()
  ? "[home_scene] init"
  m.headerScreen = m.top.findNode("headerScreen")
  m.movieListScreen = m.top.findNode("movieListScreen")
  m.searchForMoviesScreen = m.top.findNode("searchForMoviesScreen")
  m.detailsScreen = m.top.findNode("detailsScreen")
  m.castScreen = m.top.findNode("castScreen")
  m.reviewsScreen = m.top.findNode("reviewsScreen")
  m.personScreen = m.top.findNode("personScreen")
  m.errorDialog = m.top.findNode("errorDialog")
  m.videoPlayer = m.top.findNode("videoPlayer")
  initializeVideoPlayer()

  m.headerScreen.observeField("pageSelected", "onCategorySelected")
  m.searchForMoviesScreen.observeField("searchButtonClicked", "onSearchButtonClicked")
  m.movieListScreen.observeField("movieSelected", "onMovieSelected")
  m.detailsScreen.observeField("playButtonPressed", "onPlayButtonPressed")
  m.detailsScreen.observeField("fetchMovieGenres", "fetchMovieGenres")
  m.detailsScreen.observeField("additionalInformationSelected", "onAdditionalInformationSelected")
  m.detailsScreen.observeField("setMovieTitle", "setMovieTitle")
  m.castScreen.observeField("personSelected", "onPersonSelected")
  m.personScreen.observeField("fetchPersonDetails", "fetchPersonDetails")
  m.personScreen.observeField("fetchKnownFor", "fetchKnownFor")

  m.headerScreen.setFocus(true)
  configUrl = "https://run.mocky.io/v3/11c8372a-10a8-45aa-870c-db3767860bf0"
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
  else if m.castScreen.visible
    return switchScreens(m.castScreen, m.detailsScreen)
  else if m.reviewsScreen.visible
    return switchScreens(m.reviewsScreen, m.detailsScreen)
  else if m.personScreen.visible
    return switchScreens(m.personScreen, m.castScreen)
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