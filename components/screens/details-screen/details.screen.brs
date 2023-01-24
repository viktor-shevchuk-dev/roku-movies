function setDetailsContent(movieMediaList as object)
  content = createObject("roSGNode", "ContentNode")
  row = content.createChild("ContentNode")

  for each mediaName in movieMediaList.keys()
    button = movieMediaList[mediaName]
    node = row.createChild("HeaderListItemData")
    node.labelText = button.label
    node.id = button.id
    node.endpoint = button.endpoint
  end for

  m.additionalInformationList.content = content
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
  if m.top.visible = true then m.playButton.setFocus(true)
end sub

sub appendNewGenres(genresList)
  previousLabelList = m.genresList.getChildren(-1, 0)
  m.genresList.removeChildren(previousLabelList)

  for each genre in genresList
    label = createObject("roSGNode", "Label")
    label.text = genre.name
    label.id = genre.id
    m.genresList.appendChild(label)
  end for
end sub

sub onContentChange(obj)
  item = obj.getData()
  title = item.title
  posterUrl = item.posterUrl
  genresList = item.genresList

  m.title.text = title
  m.top.setMovieTitle = title
  m.description.text = item.description
  if posterUrl <> "" then m.thumbnail.uri = posterUrl
  if genresList = invalid then m.top.fetchMovieGenres = item.id else appendNewGenres(genresList)
end sub

function focusNodeOnDetailsScreen(node)
  if node.id = m.description.id then node.color = "0xddddddff" else m.description.color = "0x808080FF"

  return node.setFocus(true)
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if key = "right" and m.playButton.hasFocus()
    return focusNodeOnDetailsScreen(m.description)
  else if m.description.hasFocus() and key = "down" or key = "right"
    return focusNodeOnDetailsScreen(m.additionalInformationList)
  else if m.description.hasFocus() and key = "left"
    return focusNodeOnDetailsScreen(m.playButton)
  else if m.additionalInformationList.hasFocus() and (key = "up" or key = "left")
    return focusNodeOnDetailsScreen(m.description)
  end if

  return false
end function
