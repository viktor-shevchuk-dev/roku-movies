sub init()
  m.title = m.top.FindNode("title")
  m.description = m.top.FindNode("description")
  m.thumbnail = m.top.FindNode("thumbnail")
  m.playButton = m.top.FindNode("playButton")
  m.genresList = m.top.FindNode("genresList")
  m.top.observeField("visible", "onVisibleChange")
  m.playButton.setFocus(true)
end sub

sub onVisibleChange()
  if m.top.visible = true then
    m.playButton.setFocus(true)
  end if
end sub

sub onContentChange(obj)
  item = obj.getData()
  m.title.text = item.SHORTDESCRIPTIONLINE1
  m.description.text = item.SHORTDESCRIPTIONLINE2
  m.thumbnail.uri = item.HDGRIDPOSTERURL
  m.top.fetchMovieDetails = item.id
end sub

sub onMovieDetailsChanged(obj)
  movieDetails = obj.getData()

  for each genre in movieDetails.genres
    label = createObject("roSGNode", "Label")
    label.text = genre.name
    m.genresList.appendChild(label)
  end for
end sub

