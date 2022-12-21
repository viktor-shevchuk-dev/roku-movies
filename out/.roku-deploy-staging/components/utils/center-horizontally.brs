function centerHorizontally(node)
  nodeBoundingRect = node.boundingRect()
  centerX = (1920 - nodeBoundingRect.width) / 2
  node.translation = [centerX, node.translation[1]]

  return nodeBoundingRect
end function