sub centerHorizontally(node)
  nodeRect = node.boundingRect()
  centerX = (1920 - nodeRect.width) / 2
  node.translation = [centerX, node.translation[1]]
end sub