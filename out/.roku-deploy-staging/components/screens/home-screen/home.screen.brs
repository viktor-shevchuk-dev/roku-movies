sub onVisibleChange()
  if m.top.visible = true then m.headerList.setFocus(true)
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.headerList.itemSize = [296 * 3 + 20 * 2, 90]
  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
  m.topRatedMoviesList = m.top.FindNode("topRatedMoviesList")
  m.topRatedMoviesList.observeField("rowItemFocused", "movieFocusHandler")
  m.movieDetailWrapper = m.top.FindNode("movieDetailWrapper")
  m.movieTitle = m.top.FindNode("movieTitle")
  m.movieDescription = m.top.FindNode("movieDescription")
  m.movieBackdrop = m.top.FindNode("movieBackdrop")
end function

function setHeaderListContent(params)
  baseUrl = params.config.baseUrl
  APIKey = params.config.APIKey
  categories = params.config.categories

  data = CreateObject("roSGNode", "ContentNode")
  row = data.CreateChild("ContentNode")
  for each category in categories
    node = row.CreateChild("HeaderListItemData")
    node.labelText = category.title
    node.id = category.id
    if category.endpoint <> invalid then node.urlToMakeQuery = baseUrl + category.endpoint + APIKey
  end for
  m.headerList.content = data
end function

sub onTopRatedMoviesListChanged(obj)
  topRatedMoviesList = obj.getData()
  m.topRatedMoviesList.topRatedMoviesListContent = topRatedMoviesList
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if key = "down" and m.headerList.hasFocus()
    return m.topRatedMoviesList.setFocus(true)
  else if key = "up" and m.topRatedMoviesList.hasFocus()
    return m.headerList.setFocus(true)
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

