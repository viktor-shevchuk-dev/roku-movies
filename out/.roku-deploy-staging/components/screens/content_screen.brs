function init()
  m.content_grid = m.top.findNode("content_grid")
end function

function onFeedChanged(obj)
  feed = obj.getData()
  imageUrls = feed.imageUrls
  color = feed.color

  postercontent = createObject("roSGNode", "ContentNode")
  for each imageUrl in imageUrls
    node = createObject("roSGNode", "ContentNode")
    node.HDGRIDPOSTERURL = imageUrl
    node.SHORTDESCRIPTIONLINE1 = "This is a " + color + " cat."
    postercontent.appendChild(node)
  end for
  showpostergrid(postercontent)
end function

sub showpostergrid(content)
  m.content_grid.content = content
  m.content_grid.visible = true
  m.content_grid.setFocus(true)
end sub