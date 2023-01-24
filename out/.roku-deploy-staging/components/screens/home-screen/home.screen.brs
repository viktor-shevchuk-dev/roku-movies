sub onVisibleChange()
  if m.top.visible = true then m.headerList.setFocus(true)
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.genresMoviesList = m.top.findNode("genresMoviesList")
  m.search = m.top.findNode("search")
  m.previousBgImg = m.top.findNode("previousBgImg")
  m.currentBgImg = m.top.findNode("currentBgImg")
  m.title = m.top.findNode("title")
  m.description = m.top.findNode("description")
  m.voteAverage = m.top.findNode("voteAverage")

  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
  m.genresMoviesList.observeField("rowItemFocused", "movieFocusHandler")
  m.search.observeField("focusedChild", "searchFocusHandler")
end function

sub setHeaderListContent(headerList)
  content = createObject("roSGNode", "ContentNode")
  row = content.createChild("ContentNode")

  for each categoryName in headerList.keys()
    category = headerList[categoryName]
    headerListItem = row.createChild("HeaderListItemData")
    headerListItem.id = category.id
    headerListItem.labelText = category.label
    headerListItem.endpoint = category.endpoint
  end for

  m.headerList.content = content
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
    return m.genresMoviesList.setFocus(true)
  else if key = "right"
    return m.search.setFocus(true)
  end if
end function

function handleSearchFocusChange(key) as boolean
  if key = "left"
    return m.headerList.setFocus(true)
  else if key = "down"
    return m.genresMoviesList.setFocus(true)
  end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if m.headerList.hasFocus()
    return handleHeaderListFocusChange(key)
  else if m.genresMoviesList.hasFocus() and key = "up"
    return m.headerList.setFocus(true)
  else if m.search.hasFocus()
    return handleSearchFocusChange(key)
  end if
end function

sub showScore(percentage)
  titleBoundingRect = m.title.boundingRect()
  titleWidth = titleBoundingRect.width
  titleHeight = titleBoundingRect.height
  translationX = m.title.translation[0] + titleWidth + 42
  translationY = m.title.translation[1] + titleHeight / 2
  m.voteAverage.translation = [translationX, translationY]
  m.voteAverage.percentage = percentage
  m.voteAverage.visible = true
end sub

sub movieFocusHandler(obj)
  focusedMovie = getItemFromRowList(m.genresMoviesList, "focus")
  if focusedMovie.loading then return

  if m.currentBgImg.uri <> "" then m.previousBgImg.uri = m.currentBgImg.uri

  m.currentBgImg.uri = focusedMovie.backdropUrl
  m.title.text = focusedMovie.title
  m.description.text = focusedMovie.overview
  setFontSize(m.title, 56)
  setFontSize(m.description, 38)
  scorePercentage = focusedMovie.voteAverage * 10
STOP
  showScore(scorePercentage)
end sub