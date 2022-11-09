sub onVisibleChange()
  if m.top.visible = true then m.headerList.setFocus(true)
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.movieDetailWrapper = m.top.findNode("movieDetailWrapper")
  m.movieTitle = m.top.findNode("movieTitle")
  m.movieDescription = m.top.findNode("movieDescription")
  m.movieBackdrop = m.top.findNode("movieBackdrop")
  m.topRatedMoviesList = m.top.findNode("topRatedMoviesList")
  m.search = m.top.findNode("search")

  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
  m.topRatedMoviesList.observeField("rowItemFocused", "movieFocusHandler")
  m.search.observeField("focusedChild", "searchFocusHandler")
end function

sub setHeaderListContent(params)
  baseUrl = params.config.baseUrl
  APIKey = params.config.APIKey
  categories = params.config.categories

  headerListContent = CreateObject("roSGNode", "ContentNode")
  row = headerListContent.CreateChild("ContentNode")
  for each category in categories
    headerListItem = row.CreateChild("HeaderListItemData")
    headerListItem.id = category.id
    headerListItem.labelText = category.title
    headerListItem.urlToMakeQuery = baseUrl + category.endpoint + APIKey
  end for
  m.headerList.content = headerListContent
end sub

sub onTopRatedMoviesListChanged(obj)
  topRatedMoviesList = obj.getData()
  m.topRatedMoviesList.topRatedMoviesListContent = topRatedMoviesList
end sub

sub searchFocusHandler()
  if m.search.hasFocus()
    m.search.scale = [1.5, 1.5]
    m.search.translation = [m.search.translation[0] - 16, m.search.translation[1] - 16]
  else
    m.search.scale = [1, 1]
    m.search.translation = [m.search.translation[0] + 16, m.search.translation[1] + 16]
  end if
end sub

function handleHeaderListFocusChange(key) as boolean
  if key = "down"
    return m.topRatedMoviesList.setFocus(true)
  else if key = "right"
    return m.search.setFocus(true)
  end if
end function

function handleSearchFocusChange(key) as boolean
  if key = "left"
    return m.headerList.setFocus(true)
  else if key = "down"
    return m.topRatedMoviesList.setFocus(true)
  end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if m.headerList.hasFocus()
    return handleHeaderListFocusChange(key)
  else if m.topRatedMoviesList.hasFocus() and key = "up"
    return m.headerList.setFocus(true)
  else if m.search.hasFocus()
    return handleSearchFocusChange(key)
  end if
end function

sub changeMovieDetailContent(title, content)
  m.movieTitle.text = title
  m.movieDescription.text = content.description
  m.movieBackdrop.uri = generateImageUrl(content.backdropUrl, "500")
  if not m.movieDetailWrapper.visible then m.movieDetailWrapper.visible = true
end sub

sub movieFocusHandler()
  focusedMovie = getMovieFromRowListByEvent(m.topRatedMoviesList, "focus")
  changeMovieDetailContent(focusedMovie.title, focusedMovie.additionalInformation)
end sub

