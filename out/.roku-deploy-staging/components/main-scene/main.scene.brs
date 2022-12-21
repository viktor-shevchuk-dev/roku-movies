' fix a bug where when navigating to look for movies - list of movies displayed instead (it is because genres are still being loaded)
' I may load list of a genre one by one concurrently, not waiting for previous to load to request the next. Or even load the first two and when focusing the row - loading the next one and so forth

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

  m.homeScreen.findNode("moviesListsOfDifferentGenres").observeField("onFetchSpecificGenreMoviesList", "fetchSpecificGenreMoviesList")
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
  configUrl = "https://run.mocky.io/v3/cd0b4546-d642-4901-b5fe-e9e9740cd57d"
  ' makeRequest({ uri: configUrl }, "handleUriResult")

  context = createObject("roSGNode", "Node")
  context.addFields({
    parameters: { url: configUrl }
    response: {}
  })
  context.observeField("response", "observeResponseFromNewUriHandler")
  m.UriHandler.request = { context: context }
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

function handleReceivedMovies(movies)
  showNewScreenWithSavingCurrent(m.movieListScreen.id)
  m.movieListScreen.content = movies
end function

function handleReceivedConfig(config)
  m.APIKey = config.APIKey
  m.baseUrl = config.baseUrl
  m.homeScreen.callFunc("setHeaderListContent", config)
  m.detailsScreen.callFunc("setDetailsContent", config)
  m.movieListScreen.callFunc("updateDummyVideos", config)
  m.personScreen.callFunc("updateDummyVideos", config)
  m.homeScreen.findNode("moviesListsOfDifferentGenres").callFunc("updateDummyVideos", config)
  genresListUrl = m.baseUrl + "/genre/movie/list" + m.APIKey
  makeRequest({ uri: genresListurl }, "handleUriResult")
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

function handleMovieGenres(genresList)
  if m.homeScreen.visible
    numRows = genresList.count()

    moviesListsOfDifferentGenres = m.homeScreen.findNode("moviesListsOfDifferentGenres")
    moviesListsOfDifferentGenres.genresList = genresList

    for i = 0 to genresList.count() - 1
      genre = genresList[i]
      id = genre.id
      url = m.baseUrl + "/discover/movie" + m.APIKey + "&language=en-US&sort_by=vote_count.desc&with_genres=" + id.toStr()

      context = createObject("roSGNode", "Node")
      context.addFields({
        parameters: {
          url: url,
          num: i
        },
        response: {}
      })
      context.observeField("response", "observeResponseFromNewUriHandler")
      m.UriHandler.request = { context: context }
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

sub handleMoviesFromHomeScreen(moviesList)
  if m.category = invalid
    m.homeScreen.findNode("moviesListsOfDifferentGenres").specificGenreMoviesList = moviesList
  else if m.category.id = m.movieListScreen.id
    handleReceivedMovies(moviesList)
  end if
end sub

sub handleMovies(movies)
  if m.personScreen.visible
    handleKnownForMovies(movies)
  else if m.searchForMoviesScreen.visible
    handleReceivedMovies(movies)
  else if m.homeScreen.visible
    handleMoviesFromHomeScreen(movies)
  end if
end sub

sub handlePopularActors(popularActorsList)
  showNewScreenWithSavingCurrent(m.peopleScreen.id)
  popularActorsListContent = { title: "Popular Actors", peopleList: popularActorsList }
  m.peopleScreen.content = popularActorsListContent
end sub

function handleResults(results)
  if results[0].title <> invalid
    handleMovies(results)
  else if results[0].author <> invalid
    handleReviews(results)
  else if results[0].name <> invalid
    handlePopularActors(results)
  end if
end function

sub handlePersonDetails(personDetails)
  m.personScreen.personDetails = personDetails
end sub

sub handleData(data)
  content = data.content
  num = data.num
  parameters = data.parameters
  results = content.results
  categories = content.categories
  genres = content.genres
  cast = content.cast
  name = content.name

  if results <> invalid and results.count() > 0
    handleResults(results)
  else if categories <> invalid and categories.count() > 0
    handleReceivedConfig(content)
  else if genres <> invalid and genres.count() > 0
    handleMovieGenres(genres)
  else if cast <> invalid and cast.count() > 0
    handleCast(content.cast)
  else if name <> invalid
    handlePersonDetails(content)
  else
    showErrorDialog("No data found.")
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
  makeRequest({ uri: urlToMakeQuery }, "handleUriResult")
end sub

sub showPopularActorsList(urlToMakeQuery)
  makeRequest({ uri: urlToMakeQuery }, "handleUriResult")
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
  knownForUrl = m.baseUrl + "/discover/movie" + m.APIKey + "&language=en-US&sort_by=popularity.desc&include_adult=false&page=1&with_cast=" + personId.toStr()
  makeRequest({ uri: knownForUrl }, "handleUriResult")
end sub

sub fetchPersonDetails(obj)
  personId = obj.getData()
  personUrl = m.baseUrl + "/person/" + personId.toStr() + m.APIKey + "&language=en-US"
  makeRequest({ uri: personUrl }, "handleUriResult")
end sub

sub fetchMovieGenres(obj)
  m.movieId = obj.getData()
  genresUrl = m.baseUrl + "/movie/" + m.movieId.toStr() + m.APIKey + "&language=en-US"
  makeRequest({ uri: genresUrl }, "handleUriResult")
end sub

sub fetchSpecificGenreMoviesList(obj)
  genreId = obj.getData()
  specificGenreMoviesListUrl = m.baseUrl + "/discover/movie" + m.APIKey + "&language=en-US&sort_by=vote_count.desc&with_genres=" + genreId.toStr()
  makeRequest({ uri: specificGenreMoviesListUrl }, "handleUriResult")
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

function makeRequest(parameters as object, parserComponent as string)
  context = createObject("RoSGNode", "Node")
  if type(parameters) = "roAssociativeArray"
    context.addFields({ parameters: parameters, response: {} })
    context.observeField("response", parserComponent) ' response parserComponent is request-specific
    m.uriFetcher.request = { context: context }
  end if
end function

function onKeyEvent(key, press) as boolean
  ? "[home_scene] onKeyEvent", key, press
  if key = "back" and press then return handleBackButtonClick()

  return false
end function