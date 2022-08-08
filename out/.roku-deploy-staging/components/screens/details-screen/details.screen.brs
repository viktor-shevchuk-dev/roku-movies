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
  m.textRectangle = m.top.FindNode("textRectangle")
  m.additionalInformationList.itemSize = [296 * 3 + 20 * 2, 90]
  adjustScrollableText(m.textRectangle, m.description)
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

  if item.genres = invalid
    m.top.fetchMovieGenres = item.id
  else
    previousLabelList = m.genresList.getChildren(-1, 0)
    m.genresList.removeChildren(previousLabelList)

    for each genre in item.genres
      label = createObject("roSGNode", "Label")
      label.text = genre.name
      label.id = genre.id
      m.genresList.appendChild(label)
    end for
  end if
end sub

function focusNodeOnDetailsScreen(node)
  if node.id = m.description.id then node.color = "0xddddddff" else m.description.color = "0x808080FF"

  return node.setFocus(true)
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press
    return false
  end if

  if key = "right" and m.playButton.hasFocus()
    return focusNodeOnDetailsScreen(m.description)
  else if m.description.hasFocus() and key = "down" or key = "right"
    return focusNodeOnDetailsScreen(m.additionalInformationList)
  else if (m.description.hasFocus() or m.additionalInformationList.hasFocus()) and key = "left"
    return focusNodeOnDetailsScreen(m.playButton)
  else if key = "up" and m.additionalInformationList.hasFocus()
    return focusNodeOnDetailsScreen(m.description)
  end if

  return false
end function
