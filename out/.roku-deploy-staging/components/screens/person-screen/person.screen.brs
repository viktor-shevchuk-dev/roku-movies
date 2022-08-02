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
    item.hdposterurl = generateImageUrl(knownForMovie.poster_path, "200")
  end for
  content.appendChild(row)
  m.knownForList.content = content
end sub

sub onPersonDetailsChanged(obj)
  personDetails = obj.getData()
  m.biographyContent.text = personDetails.biography
end sub

sub adjustScrollableText()
  textRectangle = m.top.findNode("textRectangle")
  instructionbar = m.top.findNode("instructionbar")
  upDownnInstruct = m.top.findNode("upDownnInstruct")
  padding = 20
  hcenterpadding = padding * 2
  vcenterpadding = padding * 3
  instructionbar.height = vcenterpadding
  m.biographyContent.width = textRectangle.width - hcenterpadding
  m.biographyContent.height = textRectangle.height - (instructionbar.height + vcenterpadding)
  instructionbar.width = m.biographyContent.width
  instructionbar.translation = [padding, textRectangle.height - (instructionbar.height + padding)]
  upDownnInstruct.width = 300
  upDownnInstruct.height = 40
  upDownnInstruct.translation = [padding, 10]
end sub

function focusChanged()
  if m.top.isInFocusChain()
    if not m.knownForList.hasFocus()
      m.knownForList.setFocus(true)
    end if
  end if
end function

function rowFocused()
  '        print "grid row "; m.knownForList.rowFocused; " focused"
end function

function rowSelected()
  '        print "grid row "; m.knownForList.rowSelected; " selected"
end function

sub init()
  m.top.observeField("visible", "onVisibleChange")
  m.photo = m.top.findNode("photo")
  m.name = m.top.FindNode("name")
  setFontSize(m.name, 62)
  m.biography = m.top.FindNode("biography")
  m.biographyContent = m.top.findNode("biographyContent")
  m.knownForList = m.top.findNode("knownForList")
  m.simpleGridItem = m.knownForList.findNode("simpleGridItem")
  ' m.simpleGridItem.width = 200

  adjustScrollableText()

  'knownForList continue developing the rowList below with known for movies. I got the known for movies. After clicking one movie - go to movieDetails page
  m.top.observeField("focusedChild", "focusChanged")
  m.knownForList.setFocus(true)
end sub

sub onVisibleChange()
  if m.top.visible = true then
    m.biographyContent.setFocus(true)
  end if
end sub
