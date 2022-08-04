sub onVisibleChange()
  if m.top.visible = true then
    m.castGrid.setFocus(true)
  end if
end sub

sub init()
  m.castGrid = m.top.FindNode("castGrid")
  m.heading = m.top.FindNode("heading")
  m.top.observeField("visible", "onVisibleChange")
end sub

sub onCastChanged(obj)
  cast = obj.getData()
  m.heading.text = cast.title
  adjustHeading(m.heading)

  posterContent = createObject("roSGNode", "ContentNode")
  for each item in cast.cast
    node = createObject("roSGNode", "ContentNode")
    node.id = item.id
    node.HDGRIDPOSTERURL = generateImageUrl(item.profile_path, "400")
    node.SHORTDESCRIPTIONLINE1 = item.name
    node.SHORTDESCRIPTIONLINE2 = "Character: " + item.character
    posterContent.appendChild(node)
  end for
  showPosterGrid(posterContent)
end sub

sub showPosterGrid(content)
  m.castGrid.content = content
  m.castGrid.visible = true
  m.castGrid.setFocus(true)
end sub