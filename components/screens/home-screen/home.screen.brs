function generateImageUrl(filepath)
  return "https://image.tmdb.org/t/p/w300" + filepath
end function

sub onVisibleChange()
  if m.top.visible = true then
    m.homeGrid.setFocus(true)
  end if
end sub

sub init()
  m.homeGrid = m.top.FindNode("homeGrid")
  m.heading = m.top.FindNode("heading")
  m.heading.font.size = 50
  centerHorizontally(m.heading)
  m.top.observeField("visible", "onVisibleChange")
end sub

sub onTrendingDataChanged(obj)
  data = obj.getData()
  postercontent = createObject("roSGNode", "ContentNode")
  for each item in data.results
    node = createObject("roSGNode", "ContentNode")
    node.HDGRIDPOSTERURL = generateImageUrl(item.poster_path)
    node.SHORTDESCRIPTIONLINE1 = item.title
    node.SHORTDESCRIPTIONLINE2 = item.overview
    postercontent.appendChild(node)
  end for
  showpostergrid(postercontent)
end sub

sub showpostergrid(content)
  m.homeGrid.content = content
  m.homeGrid.visible = true
  m.homeGrid.setFocus(true)
end sub