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
  fetch(genresListurl)
end function

function handleMovieGenres(genresList)
  if m.homeScreen.visible
    m.homeScreen.findNode("moviesListsOfDifferentGenres").genresList = genresList
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
  results = data.results
  categories = data.categories
  genres = data.genres
  cast = data.cast
  name = data.name

  if results <> invalid and results.count() > 0
    handleResults(results)
  else if categories <> invalid and categories.count() > 0
    handleReceivedConfig(data)
  else if genres <> invalid and genres.count() > 0
    handleMovieGenres(genres)
  else if cast <> invalid and cast.count() > 0
    handleCast(data.cast)
  else if name <> invalid
    handlePersonDetails(data)
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
  fetch(urlToMakeQuery)
end sub

sub showPopularActorsList(urlToMakeQuery)
  fetch(urlToMakeQuery)
end sub

sub stopVideo()
  m.videoPlayer.control = "stop"
end sub

sub initializeVideoPlayer()
  m.videoPlayer.EnableCookies()
  m.videoPlayer.setCertificatesFile("common:/certs/ca-bundle.crt")
  m.videoPlayer.InitClientCertificates()
  m.videoPlayer.notificationInterval = 10
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
  fetch(knownForUrl)
end sub

sub fetchPersonDetails(obj)
  personId = obj.getData()
  personUrl = m.baseUrl + "/person/" + personId.toStr() + m.APIKey + "&language=en-US"
  fetch(personUrl)
end sub

sub fetchMovieGenres(obj)
  m.movieId = obj.getData()
  genresUrl = m.baseUrl + "/movie/" + m.movieId.toStr() + m.APIKey + "&language=en-US"
  fetch(genresUrl)
end sub

sub fetchSpecificGenreMoviesList(obj)
  genreId = obj.getData()
  specificGenreMoviesListUrl = m.baseUrl + "/discover/movie" + m.APIKey + "&language=en-US&sort_by=vote_count.desc&with_genres=" + genreId.toStr()
  fetch(specificGenreMoviesListUrl)
end sub

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
  configUrl = "https://run.mocky.io/v3/cd0b4546-d642-4901-b5fe-e9e9740cd57d"
  fetch(configUrl)
  m.homeScreen.setFocus(true)
end function

function onKeyEvent(key, press) as boolean
  ? "[home_scene] onKeyEvent", key, press
  if key = "back" and press then return handleBackButtonClick()

  return false
end function