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

sub onDataChanged(obj)
  moviesList = obj.getData()
  posterContent = createObject("roSGNode", "ContentNode")
  for each movie in moviesList
    node = createObject("roSGNode", "ContentNode")
    node.id = movie.id
    node.streamformat = "mp4"
    node.url = getRandomVideoUrl(m.dummyVideos)

    node.HDGRIDPOSTERURL = generateImageUrl(movie.poster_path, "300")
    node.SHORTDESCRIPTIONLINE1 = movie.title
    node.SHORTDESCRIPTIONLINE2 = movie.overview
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