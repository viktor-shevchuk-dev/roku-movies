sub center(node)
  nodeBoundingRect = centerHorizontally(node)
  centerY = (1080 - nodeBoundingRect.height) / 2
  node.translation = [node.translation[0], centerY]
end sub