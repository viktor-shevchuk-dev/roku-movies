sub onVisibleChange()
  if m.top.visible = true then m.headerList.setFocus(true)
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.moviesListsOfDifferentGenres = m.top.findNode("moviesListsOfDifferentGenres")
  m.search = m.top.findNode("search")
  m.previousBgImg = m.top.findNode("previousBgImg")
  m.currentBgImg = m.top.findNode("currentBgImg")

  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
  m.moviesListsOfDifferentGenres.observeField("rowItemFocused", "movieFocusHandler")
  m.search.observeField("focusedChild", "searchFocusHandler")
end function

sub setHeaderListContent(config)
  baseUrl = config.baseUrl
  APIKey = config.APIKey
  categories = config.categories

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
    return m.moviesListsOfDifferentGenres.setFocus(true)
  else if key = "right"
    return m.search.setFocus(true)
  end if
end function

function handleSearchFocusChange(key) as boolean
  if key = "left"
    return m.headerList.setFocus(true)
  else if key = "down"
    return m.moviesListsOfDifferentGenres.setFocus(true)
  end if
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if m.headerList.hasFocus()
    return handleHeaderListFocusChange(key)
  else if m.moviesListsOfDifferentGenres.hasFocus() and key = "up"
    return m.headerList.setFocus(true)
  else if m.search.hasFocus()
    return handleSearchFocusChange(key)
  end if
end function

sub movieFocusHandler()
  focusedMovie = getItemFromRowList(m.moviesListsOfDifferentGenres, "focus")

  if m.currentBgImg.uri <> "" then m.previousBgImg.uri = m.currentBgImg.uri

  m.currentBgImg.uri = focusedMovie.backdropUrl
end sub