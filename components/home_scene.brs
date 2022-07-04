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

function init()
  ? "[home_scene] init"
  m.headerScreen = m.top.findNode("headerScreen")
  m.movieListScreen = m.top.findNode("movieListScreen")
  m.searchForMoviesScreen = m.top.findNode("searchForMoviesScreen")

  m.headerScreen.observeField("pageSelected", "onCategorySelected")
  m.searchForMoviesScreen.observeField("searchButtonClicked", "onSearchButtonClicked")
  m.headerScreen.setFocus(true)
end function

function handleBackButtonClick()
  if m.movieListScreen.visible or m.searchForMoviesScreen.visible
    m.movieListScreen.visible = false
    m.searchForMoviesScreen.visible = false

    m.headerScreen.visible = true
    m.headerScreen.setFocus(true)
    return true
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