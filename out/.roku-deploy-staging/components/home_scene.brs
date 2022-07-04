sub showCategory(screen)
  m.headerScreen.visible = false
  screenToShow = m.top.findNode(screen)
  screenToShow.visible = true
end sub

sub onTrendingResponse(obj)
  response = obj.getData()
  data = ParseJson(response)
  if data <> invalid and data.results <> invalid
    showCategory(m.homeScreen.id)
    m.homeScreen.trendingData = data
  else
    ? "TRENDING RESPONSE IS EMPTY"
  end if
end sub

sub loadUrl(url)
  m.trending_task = createObject("roSGNode", "LoadTrendingTask")
  m.trending_task.observeField("response", "onTrendingResponse")
  m.trending_task.url = url
  m.trending_task.control = "RUN"
end sub

sub onCategorySelected(obj)
  list = m.headerScreen.findNode("headerList")
  index = obj.getData()
  item = list.content.getChild(index)
  if item.urlToMakeQuery = ""
    showCategory(item.id)
  else
    loadUrl(item.urlToMakeQuery)
  end if
end sub

function init()
  ? "[home_scene] init"
  m.headerScreen = m.top.findNode("HeaderScreen")
  m.homeScreen = m.top.findNode("HomeScreen")
  m.movieListScreen = m.top.findNode("MovieListScreen")

  m.headerScreen.observeField("pageSelected", "onCategorySelected")
  m.headerScreen.setFocus(true)
end function

function handleBackButtonClick()
  if m.homeScreen.visible or m.movieListScreen.visible
    m.homeScreen.visible = false
    m.movieListScreen.visible = false

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