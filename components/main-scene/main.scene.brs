' fix a bug where when navigating to look for movies - list of movies displayed instead (it is because genres are still being loaded)
' I may load list of a genre one by one concurrently, not waiting for previous to load to request the next. Or even load the first two and when focusing the row - loading the next one and so forth
' check every and debug function what it does and potentially maybe some values are useless.

function init()
  m.homeScreen = m.top.findNode("homeScreen")
  m.movieListScreen = m.top.findNode("movieListScreen")
  m.searchForMoviesScreen = m.top.findNode("searchForMoviesScreen")
  m.detailsScreen = m.top.findNode("detailsScreen")
  m.peopleScreen = m.top.findNode("peopleScreen")
  m.reviewsScreen = m.top.findNode("reviewsScreen")
  m.personScreen = m.top.findNode("personScreen")
  m.errorDialog = m.top.findNode("errorDialog")
  m.videoPlayer = m.top.findNode("videoPlayer")

  m.homeScreen.observeField("pageSelected", "categoryClickHandler")
  m.homeScreen.observeField("searchForMoviesPageSelected", "searchClickHandler")
  m.searchForMoviesScreen.observeField("searchButtonClicked", "searchButtonClickHandler")
  m.movieListScreen.observeField("movieSelected", "movieClickHandler")
  m.personScreen.observeField("knownForMovieSelected", "knownForMovieClickHandler")
  m.homeScreen.observeField("movieSelected", "specificGenreMovieClickHandler")
  m.detailsScreen.observeField("playButtonPressed", "playButtonClickHandler")
  m.detailsScreen.observeField("fetchMovieGenres", "fetchMovieGenres")
  m.detailsScreen.observeField("additionalInformationSelected", "additionalInformationClickHandler")
  m.detailsScreen.observeField("setMovieTitle", "setMovieTitle")
  m.peopleScreen.observeField("personSelected", "personCLickHandler")
  m.personScreen.observeField("fetchPersonDetails", "fetchPersonDetails")
  m.personScreen.observeField("fetchKnownFor", "fetchKnownFor")

  initializeVideoPlayer()
  m.screensHistory = []
  m.homeScreen.setFocus(true)
  m.uriFetcher = createObject("roSGNode", "UriFetcher")

  m.UriHandler = createObject("roSGNode", "UriHandler")
  m.UriHandler.observeField("content", "onContentChanged")
  ' makeRequest({ uri: configUrl })
  m.config = { baseUrl: "https://run.mocky.io/v3/a4803a81-dcb6-4d5c-a353-994916449a5c" }
  makeRequest({ url: m.config.baseUrl })
end function

function showScreen(screen)
  m.top.focusedChild.visible = false
  screenToShow = m.top.findNode(screen.screenId)
  screenToShow.visible = true
  if screen.content <> invalid then screenToShow.content = screen.content
  screenToShow.setFocus(true)

  return true
end function

sub showNewScreenWithSavingCurrent(screenToShowId)
  currentScreen = m.top.findNode(m.top.focusedChild.id)
  historyItem = { screenId: m.top.focusedChild.id, content: currentScreen.content }
  m.screensHistory.push(historyItem)
  showScreen({ screenId: screenToShowId })
end sub

function handleMovies(movies)
  showNewScreenWithSavingCurrent(m.movieListScreen.id)
  m.movieListScreen.content = movies
end function

function saveEndpointsList(sectionsList)
  m.movieDB = {}

  for each sectionName in sectionsList.keys()
    section = sectionsList[sectionName]
    for each endpointName in section.keys()
      m.movieDB[endpointName] = section[endpointName]
    end for
  end for
end function

function handleConfig(config)
  m.global.addFields({ movieDB: { baseURL: config.baseURL, APIKey: config.APIKey } })
  movieDB = config.movieDB
  dummyVideosList = config.dummyVideosList
  saveEndpointsList(movieDB)

  m.homeScreen.callFunc("setHeaderListContent", movieDB.categoriesList)
  m.detailsScreen.callFunc("setDetailsContent", movieDB.movieMedia)
  m.movieListScreen.callFunc("updateDummyVideos", dummyVideosList)
  m.personScreen.callFunc("updateDummyVideos", dummyVideosList)
  m.homeScreen.findNode("moviesListsOfDifferentGenres").callFunc("updateDummyVideos", dummyVideosList)

  genresListUrl = getMovieDBUrl(m.movieDB.genresList.endpoint)
  makeRequest({ url: genresListurl })
end function

sub onContentChanged()
  ' m.top.numBadRequests = m.UriHandler.numBadRequests
  m.homeScreen.findNode("moviesListsOfDifferentGenres").content = m.UriHandler.content
end sub

function observeResponseFromNewUriHandler(obj)
  response = obj.getData()
  m.parseResponseTask = createObject("roSGNode", "parseResponseTask")
  m.parseResponseTask.observeField("error", "parseJsonErrorHandler")
  m.parseResponseTask.observeField("parsedResponse", "parsedResponseHandler")
  m.parseResponseTask.response = response
  m.parseResponseTask.control = "run"
end function

function handleGenresList(genresList)
  if m.homeScreen.visible
    numRows = genresList.count()

    m.homeScreen.findNode("moviesListsOfDifferentGenres").genresList = genresList

    for i = 0 to numRows - 1
      genre = genresList[i]
      searchParamsList = []
      searchParamsList = m.movieDB.genreMoviesList.searchParamsList
      searchParamsList.addReplace("with_genres", genre.id)
      genreMoviesListUrl = getMovieDBUrl(m.movieDB.genreMoviesList.endpoint, searchParamsList)
      makeRequest({ url: genreMoviesListUrl, num: i })
    end for
  else if m.detailsScreen.visible
    content = m.detailsScreen.content
    content.genres = genresList
    m.detailsScreen.content = content
  end if
end function

function handleCast(cast)
  showNewScreenWithSavingCurrent(m.peopleScreen.id)
  castContent = { title: "Cast of " + m.movieTitle, peopleList: cast }
  m.peopleScreen.content = castContent
end function

function handleReviews(reviews)
  showNewScreenWithSavingCurrent(m.reviewsScreen.id)
  reviewsContent = { title: "Reviews of " + m.movieTitle, reviews: reviews }
  m.reviewsScreen.content = reviewsContent
end function

sub handleKnownForMovies(movies)
  m.personScreen.knownForMovies = movies
end sub

sub handlePopularActors(popularActorsList)
  showNewScreenWithSavingCurrent(m.peopleScreen.id)
  popularActorsListContent = { title: "Popular Actors", peopleList: popularActorsList }
  m.peopleScreen.content = popularActorsListContent
end sub

sub handlePersonDetails(personDetails)
  m.personScreen.personDetails = personDetails
end sub

function handleMovieGenresList(genresList)
  content = m.detailsScreen.content
  content.genresList = genresList
  m.detailsScreen.content = content
end function

sub handleGenreMoviesList(moviesList)
  m.homeScreen.findNode("moviesListsOfDifferentGenres").specificGenreMoviesList = moviesList
end sub

sub handleData(data)
  url = data.url
  content = data.content
  results = content.results
  genresList = content.genres
  ' fix order of fetching movies of certain genre on home screen. I get a num. So I can guarantee a right order.
  ' add timer to brightscript and check why first 20 lists of movies by different genres load and only then popular by week screen opens
  if isMatch(m.config.baseUrl, url)
    handleConfig(content)
  else if isMatch(m.movieDB.genresList.endpoint, url)
    handleGenresList(genresList)
  else if isMatch(m.movieDB.reviewsList.endpoint.split("/")[3], url)
    handleReviews(results)
  else if isMatch(m.movieDB.popularActorsList.endpoint, url)
    handlePopularActors(results)
  else if isMatch(m.movieDB.knownFor.searchParamsList.keys()[1], url)
    handleKnownForMovies(results)
  else if isMatch(m.movieDB.cast.endpoint.split("/")[3], url)
    handleCast(content.cast)
  else if isMatch(m.movieDB.person.endpoint, url)
    handlePersonDetails(content)
  else if isMatch(m.movieDB.search.endpoint, url)
    handleMovies(results)
  else if isMatch(m.movieDB.genreMoviesList.searchParamsList.keys()[1], url)
    handleGenreMoviesList(results)
  else if isMatch(m.movieDB.home.endpoint, url)
    handleMovies(results)
  else if isMatch(m.movieDB.movie.endpoint, url)
    handleMovieGenresList(genresList)
  end if
end sub

sub fetch(url)
  m.fetchTask = createObject("roSGNode", "fetchTask")
  m.fetchTask.observeField("error", "fetchErrorHandler")
  m.fetchTask.observeField("response", "fetchResponseHandler")
  m.fetchTask.url = url
  m.fetchTask.control = "RUN"
end sub

sub showTrendingThisWeek(urlToMakeQuery)
  m.movieListScreen.title = "Trending This Week"
  makeRequest({ url: urlToMakeQuery })
end sub

sub showPopularActorsList(urlToMakeQuery)
  makeRequest({ url: urlToMakeQuery })
end sub

sub stopVideo()
  m.videoPlayer.control = "stop"
end sub

sub initializeVideoPlayer()
  m.videoPlayer.enableCookies()
  m.videoPlayer.setCertificatesFile("common:/certs/ca-bundle.crt")
  developerID = createObject("roAppInfo").getValue("developer_ID").toStr()
  m.videoPlayer.addHeader("X-Roku-Reserved-Dev-Id", developerID)
  m.videoPlayer.initClientCertificates()
  m.videoPlayer.observeFieldScoped("position", "playerPositionChangeHandler")
  m.videoPlayer.observeFieldScoped("state", "playerStateChangeHandler")
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
  searchParamsList = m.movieDB.knownFor.searchParamsList
  searchParamsList.addReplace("with_cast", personId)

  knownForUrl = getMovieDBUrl(m.movieDB.knownFor.endpoint, searchParamsList)
  makeRequest({ url: knownForUrl })
end sub

sub fetchPersonDetails(obj)
  personId = obj.getData()
  personUrl = getMovieDBUrl(m.movieDB.person.endpoint, personId)
  makeRequest({ url: personUrl })
end sub

sub fetchMovieGenres(obj)
  m.movieId = obj.getData()
  movieGenresListUrl = getMovieDBUrl(m.movieDB.movie.endpoint, m.movieId)
  makeRequest({ url: movieGenresListUrl })
end sub

function handleUriResult(msg as object)
  messageType = type(msg)
  if messageType = "roSGNodeEvent"
    context = msg.getRoSGNode()
    response = msg.getData()
    responseType = type(response)
    if responseType = "roAssociativeArray"
      content = response.content
      responseContentType = type(content)
      if responseContentType = "roString"
        m.parseResponseTask = createObject("roSGNode", "parseResponseTask")
        m.parseResponseTask.observeField("error", "parseJsonErrorHandler")
        m.parseResponseTask.observeField("parsedResponse", "parsedResponseHandler")
        m.parseResponseTask.response = response
        m.parseResponseTask.control = "run"
      else
        showErrorDialog("Unknown response content type - " + responseContentType + ".")
      end if
    else
      showErrorDialog("Unknown response type - " + responseType + ".")
    end if
  else
    showErrorDialog("Unknown message type - " + messageType + ".")
  end if
end function

function makeRequest(parameters as object)
  context = createObject("roSGNode", "Node")
  context.addFields({ parameters: parameters, response: {} })
  context.observeField("response", "observeResponseFromNewUriHandler")
  m.uriHandler.request = { context: context }
end function

function onKeyEvent(key, press) as boolean
  ? "[home_scene] onKeyEvent", key, press
  if key = "back" and press then return handleBackButtonClick()

  return false
end function