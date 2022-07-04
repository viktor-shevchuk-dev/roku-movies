sub center(node)
  nodeRect = node.boundingRect()
  centerx = (1920 - nodeRect.width) / 2
  centery = (1080 - nodeRect.height) / 2
  node.translation = [centerx, centery]
end sub

sub centerHorizontally(node)
  nodeRect = node.boundingRect()
  x = (1920 - nodeRect.width) / 2
  node.translation = [x, node.translation[1]]
end sub

sub setFontSize(node, size)
  node.font.size = size
end sub

sub adjustHeading(node)
  centerHorizontally(node)
  setFontSize(node, 50)
end sub