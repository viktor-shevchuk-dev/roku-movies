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

  m.title.text = item.title
  m.description.text = item.description
  if item.posterUrl <> ""
    m.thumbnail.uri = item.posterUrl
  end if
  m.top.setMovieTitle = item.title

  ' fix adding genres on top of previous
  if item.genres = invalid
    m.top.fetchMovieGenres = item.id
  else
    oldLabelList = m.genresList.getChildren(-1, 0)
    m.genresList.removeChildren(oldLabelList)

    for each genre in item.genres
      label = createObject("roSGNode", "Label")
      label.text = genre.name
      label.id = genre.id
      m.genresList.appendChild(label)
    end for
  end if
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