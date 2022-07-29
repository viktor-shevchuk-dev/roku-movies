sub onContentChange(obj)
  personItem = obj.getData()
  m.top.fetchPersonDetails = personItem.id
  m.photo.uri = personItem.HDGRIDPOSTERURL
  m.name.text = personItem.SHORTDESCRIPTIONLINE1

end sub

sub onPersonDetailsChanged(obj)
  personDetails = obj.getData()
  m.biographyContent.text = personDetails.biography
  ' continue here
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

sub init()
  m.top.observeField("visible", "onVisibleChange")
  m.photo = m.top.findNode("photo")
  m.name = m.top.FindNode("name")
  setFontSize(m.name, 62)
  m.biography = m.top.FindNode("biography")
  setFontSize(m.biography, 50)
  m.biographyContent = m.top.findNode("biographyContent")

  adjustScrollableText()
  m.biographyContent.setFocus(true)
end sub

sub onVisibleChange()
  if m.top.visible = true then
    m.biographyContent.setFocus(true)
  end if
end sub
