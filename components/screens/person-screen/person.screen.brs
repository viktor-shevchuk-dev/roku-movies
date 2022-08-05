sub onContentChange(obj)
  personItem = obj.getData()
  m.top.fetchPersonDetails = personItem.id
  m.top.fetchKnownFor = personItem.id
  m.photo.uri = personItem.HDGRIDPOSTERURL
  m.name.text = personItem.SHORTDESCRIPTIONLINE1
end sub

sub onKnownForMoviesChanged(obj)
  knownForMovies = obj.getData()

  content = createObject("roSGNode", "ContentNode")
  row = CreateObject("rosgnode", "ContentNode")
  for each knownForMovie in knownForMovies
    item = row.CreateChild("ContentNode")
    item.title = knownForMovie.original_title
    item.hdposterurl = generateImageUrl(knownForMovie.poster_path, "300")
    item.id = knownForMovie.id
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
  if m.top.visible = true then
    m.biographyContent.setFocus(true)
  end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
  if key = "right" and press and m.biographyContent.hasFocus()
    m.knownForList.setFocus(true)

    return true
  else if key = "up" and press and m.knownForList.hasFocus()
    m.biographyContent.setFocus(true)

    return true
  end if

  return false
end function