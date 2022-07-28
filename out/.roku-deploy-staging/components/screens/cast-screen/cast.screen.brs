sub onVisibleChange()
  if m.top.visible = true then
    m.homeGrid.setFocus(true)
  end if
end sub

sub init()
  m.homeGrid = m.top.FindNode("homeGrid")
  m.heading = m.top.FindNode("heading")
  m.top.observeField("visible", "onVisibleChange")
end sub

sub onCastChanged(obj)
  cast = obj.getData()
  posterContent = createObject("roSGNode", "ContentNode")
  for each item in cast
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
  m.homeGrid.content = content
  m.homeGrid.visible = true
  m.homeGrid.setFocus(true)
end sub

sub onTitleChanged(obj)
  title = obj.getData()
  m.heading.text = title
  adjustHeading(m.heading)
end sub