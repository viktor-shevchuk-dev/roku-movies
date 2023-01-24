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