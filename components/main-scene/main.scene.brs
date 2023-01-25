' fix a bug where when navigating to look for movies - list of movies displayed instead (it is because genres are still being loaded)
' I may load list of a genre one by one concurrently, not waiting for previous to load to request the next. Or even load the first two and when focusing the row - loading the next one and so forth
' check every and debug function what it does and potentially maybe some values are useless.

sub init()
  ' m.top.backgroundURI = "pkg:/images/Roku-Safe-Zones-FHD.png"
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
  genresMoviesList = m.homeScreen.findNode("genresMoviesList").observeField("genreMoviesListParameters", "genreMoviesListParametersHandler")

  initializeVideoPlayer()
  m.screensHistory = []
  m.homeScreen.setFocus(true)
  m.uriFetcher = createObject("roSGNode", "UriFetcher")

  m.uriHandler = createObject("roSGNode", "UriHandler")

  m.config = {
    baseUrl: "https://run.mocky.io/v3/d819f04a-9c35-438b-89ee-7d47357ea214"
  }
  makeRequest({ url: m.config.baseUrl })

end sub

sub observeResponseFromNewUriHandler(obj)
  response = obj.getData()
  parseResponseTask = createObject("roSGNode", "parseResponseTask")
  parseResponseTask.observeField("error", "parseJsonErrorHandler")
  parseResponseTask.observeField("parsedResponse", "parsedResponseHandler")
  parseResponseTask.response = response
  parseResponseTask.control = "run"
end sub

sub makeRequest(parameters as object)
  context = createObject("roSGNode", "Node")
  context.addFields({ parameters: parameters, response: {} })
  context.observeField("response", "observeResponseFromNewUriHandler")
  m.uriHandler.request = { context: context }
end sub

sub genreMoviesListParametersHandler(event)
  genreMoviesListParameters = event.getData()
  makeRequest(genreMoviesListParameters)
end sub

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

sub loadGenresList()
  makeRequest({
    url: getMovieDBUrl(m.global.movieDB.endpointsList.genresList.endpoint)
  })
  genresMoviesList = m.homeScreen.findNode("genresMoviesList")
  genresMoviesList.numRows = 18
  genresMoviesList.content = createObject("roSGNode", "ContentNode")
  genresMoviesList.content.id = "genresMoviesListContent"
  genresListTask = createObject("roSGNode", "GenresListTask")
  genresListTask.genresList = {
    genresList: { loading: true }
    parent: genresMoviesList.content
  }
  genresListTask.control = "run"
end sub

function handleConfig(config)
  movieDB = config.movieDB
  endpointsList = {}

  for each sectionName in movieDB.keys()
    section = movieDB[sectionName]
    for each endpointName in section.keys()
      endpointsList[endpointName] = section[endpointName]
    end for
  end for

  m.global.addFields({
    movieDB: {
      baseURL: config.baseURL,
      APIKey: config.APIKey,
      endpointsList: endpointsList
    },
    dummyVideosList: config.dummyVideosList
  })
  m.homeScreen.callFunc("setHeaderListContent", movieDB.categoriesList)
  m.detailsScreen.callFunc("setDetailsContent", movieDB.movieMedia)
  loadGenresList()
end function

function handleGenresList(genresList)
  ' instead of finding Node - just make passing the data between hierarchy components
  ' in json transfer apiKey and baseUrl - into movieDB object
  genresMoviesList = m.homeScreen.findNode("genresMoviesList")
  genresMoviesList.genresList = genresList
end function

function handleCast(cast)
  showNewScreenWithSavingCurrent(m.peopleScreen.id)
  castContent = { title: substitute("Cast of {0}", m.movieTitle), peopleList: cast }
  m.peopleScreen.content = castContent
end function

function handleReviews(reviews)
  showNewScreenWithSavingCurrent(m.reviewsScreen.id)
  reviewsContent = { title: substitute("Reviews of {0}", m.movieTitle), reviews: reviews }
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

sub handleGenreMoviesList(row as object)
  m.homeScreen.findNode("genresMoviesList").specificGenreMoviesList = row
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
  else if isMatch(m.global.movieDB.endpointsList.genresList.endpoint, url)
    handleGenresList(genresList)
  else if isMatch(m.global.movieDB.endpointsList.reviewsList.endpoint.split("/")[3], url)
    handleReviews(results)
  else if isMatch(m.global.movieDB.endpointsList.popularActorsList.endpoint, url)
    handlePopularActors(results)
  else if isMatch(m.global.movieDB.endpointsList.knownFor.searchParamsList.keys()[1], url)
    handleKnownForMovies(results)
  else if isMatch(m.global.movieDB.endpointsList.cast.endpoint.split("/")[3], url)
    handleCast(content.cast)
  else if isMatch(m.global.movieDB.endpointsList.person.endpoint, url)
    handlePersonDetails(content)
  else if isMatch(m.global.movieDB.endpointsList.search.endpoint, url)
    handleMovies(results)
  else if isMatch(m.global.movieDB.endpointsList.genreMoviesList.searchParamsList.keys()[1], url)
    handleGenreMoviesList({ num: data.num, moviesList: results })
  else if isMatch(m.global.movieDB.endpointsList.home.endpoint, url)
    handleMovies(results)
  else if isMatch(m.global.movieDB.endpointsList.movie.endpoint, url)
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
  searchParamsList = m.global.movieDB.endpointsList.knownFor.searchParamsList
  key = searchParamsList.keys()[1]
  searchParamsList.addReplace(key, personId)
  knownForUrl = getMovieDBUrl(m.global.movieDB.endpointsList.knownFor.endpoint, searchParamsList)
  makeRequest({ url: knownForUrl })
end sub

sub fetchPersonDetails(obj)
  personId = obj.getData()
  personUrl = getMovieDBUrl(m.global.movieDB.endpointsList.person.endpoint, personId)
  makeRequest({ url: personUrl })
end sub

sub fetchMovieGenres(obj)
  m.movieId = obj.getData()
  movieGenresListUrl = getMovieDBUrl(m.global.movieDB.endpointsList.movie.endpoint, m.movieId)
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

function onKeyEvent(key, press) as boolean
  ? "[home_scene] onKeyEvent", key, press
  if key = "back" and press then return handleBackButtonClick()

  return false
end function