sub onContentChange(obj)
  personItem = obj.getData()
  m.top.fetchPersonDetails = personItem.id
  m.top.fetchKnownFor = personItem.id
  m.photo.uri = personItem.HDGRIDPOSTERURL
  m.name.text = personItem.SHORTDESCRIPTIONLINE1
end sub

function updateDummyVideos(config)
  m.dummyVideos = config.dummyVideos
end function

sub onKnownForMoviesChanged(obj)
  knownForMovies = obj.getData()

  content = createObject("roSGNode", "ContentNode")
  row = CreateObject("rosgnode", "ContentNode")
  for each knownForMovie in knownForMovies
    item = row.CreateChild("ContentNode")
    item.title = knownForMovie.original_title
    item.hdposterurl = generateImageUrl(knownForMovie.poster_path, "300", "450")
    item.id = knownForMovie.id
    item.streamformat = "mp4"
    item.url = getRandomVideoUrl(m.dummyVideos)
    item.SHORTDESCRIPTIONLINE1 = knownForMovie.original_title
    item.SHORTDESCRIPTIONLINE2 = knownForMovie.overview
  end for
  content.appendChild(row)
  m.knownForList.content = content
end sub

sub onPersonDetailsChanged(obj)
  personDetails = obj.getData()
  m.biographyContent.text = personDetails.biography
end sub

sub init()
  m.top.observeField("visible", "onVisibleChange")
  m.photo = m.top.findNode("photo")
  m.name = m.top.FindNode("name")
  setFontSize(m.name, 62)
  m.biography = m.top.FindNode("biography")
  m.biographyContent = m.top.findNode("biographyContent")
  m.knownForList = m.top.findNode("knownForList")
  m.textRectangle = m.top.FindNode("textRectangle")
  adjustScrollableText(m.textRectangle, m.biographyContent)

  m.biographyContent.setFocus(true)
end sub

sub onVisibleChange()
  if m.top.visible = true then m.biographyContent.setFocus(true)
end sub

function focusNodeOnPersonScreen(node)
  if node.id = m.biographyContent.id then node.color = "0xddddddff" else m.biographyContent.color = "0x808080FF"

  return node.setFocus(true)
end function

function onKeyEvent(key as string, press as boolean) as boolean
  if not press then return false

  if m.biographyContent.hasFocus() and key = "right" or key = "down"
    return focusNodeOnPersonScreen(m.knownForList)
  else if key = "up" and m.knownForList.hasFocus()
    return focusNodeOnPersonScreen(m.biographyContent)
  end if

  return false
end function