sub onVisibleChange()
  if m.top.visible = true then m.homeGrid.setFocus(true)
end sub

sub init()
  m.homeGrid = m.top.FindNode("homeGrid")
  m.heading = m.top.FindNode("heading")
  m.top.observeField("visible", "onVisibleChange")
end sub

sub onTitleChanged(obj)
  title = obj.getData()
  m.heading.text = title
  adjustHeading(m.heading)
end sub

function getVideoUrl()
  dummyVideosCount = m.dummyVideos.count()
  url = m.dummyVideos[RND(dummyVideosCount)]
  return url
end function

sub onDataChanged(obj)
  results = obj.getData()
  posterContent = createObject("roSGNode", "ContentNode")
  for each item in results
    node = createObject("roSGNode", "ContentNode")
    node.id = item.id
    node.streamformat = "mp4"
    node.url = getVideoUrl()

    node.HDGRIDPOSTERURL = generateImageUrl(item.poster_path, "300")
    node.SHORTDESCRIPTIONLINE1 = item.title
    node.SHORTDESCRIPTIONLINE2 = item.overview
    posterContent.appendChild(node)
  end for
  showPosterGrid(posterContent)
end sub

sub showPosterGrid(content)
  m.homeGrid.content = content
  m.homeGrid.visible = true
  m.homeGrid.setFocus(true)
end sub

function updateDummyVideos(params)
  m.dummyVideos = params.config.dummyVideos
end function