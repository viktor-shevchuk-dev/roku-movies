sub center(node)
  nodeRect = node.boundingRect()
  centerX = (1920 - nodeRect.width) / 2
  centerY = (1080 - nodeRect.height) / 2
  node.translation = [centerX, centerY]
end sub

sub centerHorizontally(node)
  nodeRect = node.boundingRect()
  centerX = (1920 - nodeRect.width) / 2
  node.translation = [centerX, node.translation[1]]
end sub

sub setFontSize(node, size)
  node.font.size = size
end sub

sub adjustHeading(node)
  centerHorizontally(node)
  setFontSize(node, 50)
end sub

function generateImageUrl(filepath, w)
  if filepath = invalid
    return ""
  end if

  return "https://image.tmdb.org/t/p/w" + w + filepath
end function

sub adjustScrollableText(textRectangleNode, scrollableTextNode)
  instructionbar = textRectangleNode.findNode("instructionbar")
  upDownnInstruct = textRectangleNode.findNode("upDownnInstruct")
  padding = 20
  hcenterpadding = padding * 2
  vcenterpadding = padding * 3
  instructionbar.height = vcenterpadding
  scrollableTextNode.width = textRectangleNode.width - hcenterpadding
  scrollableTextNode.height = textRectangleNode.height - (instructionbar.height + vcenterpadding)
  instructionbar.width = scrollableTextNode.width
  instructionbar.translation = [padding, textRectangleNode.height - (instructionbar.height + padding)]
  upDownnInstruct.width = 300
  upDownnInstruct.height = 40
  upDownnInstruct.translation = [padding, 10]
end sub