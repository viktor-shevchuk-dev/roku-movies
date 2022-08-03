function setDetailsContent(params)
  baseUrl = params.config.baseUrl
  APIKey = params.config.APIKey
  additionalInformation = params.config.additionalInformation

  data = CreateObject("roSGNode", "ContentNode")
  row = data.CreateChild("ContentNode")
  for each button in additionalInformation
    node = row.CreateChild("HeaderListItemData")
    node.labelText = button.title
    node.id = button.id
    node.urlToMakeQuery = button.endpoint
  end for

  m.additionalInformationList.content = data
end function

sub init()
  m.title = m.top.FindNode("title")
  m.description = m.top.FindNode("description")
  m.thumbnail = m.top.FindNode("thumbnail")
  m.playButton = m.top.FindNode("playButton")
  m.genresList = m.top.FindNode("genresList")
  m.additionalInformationList = m.top.FindNode("additionalInformationList")
  m.additionalInformationList.itemSize = [296 * 3 + 20 * 2, 90]
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
  if item.HDGRIDPOSTERURL <> ""
    m.thumbnail.uri = item.HDGRIDPOSTERURL
  else if item.HDPOSTERURL <> ""
    m.thumbnail.uri = item.HDPOSTERURL
  end if
  m.top.fetchMovieGenres = item.id
  m.top.setMovieTitle = item.SHORTDESCRIPTIONLINE1
end sub

sub onMovieDetailsChanged(obj)
  movieDetails = obj.getData()

  for each genre in movieDetails.genres
    label = createObject("roSGNode", "Label")
    label.text = genre.name
    m.genresList.appendChild(label)
  end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  isRightOrDownKey = key = "right" or key = "down"
  if not key = "OK" and isRightOrDownKey and press and m.playButton.hasFocus()
    m.additionalInformationList.setFocus(true)
    return true
  else if m.additionalInformationList.hasFocus() and key = "left"
    m.playButton.setFocus(true)
    return true
  end if
end function