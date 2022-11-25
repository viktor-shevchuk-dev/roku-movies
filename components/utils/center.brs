sub center(node)
  nodeRect = node.boundingRect()
  centerX = (1920 - nodeRect.width) / 2
  centerY = (1080 - nodeRect.height) / 2
  node.translation = [centerX, centerY]
end sub