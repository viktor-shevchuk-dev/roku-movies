function generateImageUrl(filepath)
  if filepath = invalid
    return ""
  end if

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

sub onTitleChanged(obj)
  title = obj.getData()
  m.heading.text = title
end sub

sub loadUrl(url)
  m.asyncTask = createObject("roSGNode", "LoadAsyncTask")
  m.asyncTask.observeField("response", "onAsyncTaskResponse")
  m.asyncTask.url = url
  m.asyncTask.control = "RUN"
end sub

function getVideoUrl()
  dummyVideosCount = m.dummyVideos.count()
  url = m.dummyVideos[RND(dummyVideosCount)]
  return url
end function

sub onDataChanged(obj)
  data = obj.getData()
  posterContent = createObject("roSGNode", "ContentNode")
  for each item in data.results
    node = createObject("roSGNode", "ContentNode")
    node.id = item.id
    node.streamformat = "mp4"
    node.url = getVideoUrl()

    node.HDGRIDPOSTERURL = generateImageUrl(item.poster_path)
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