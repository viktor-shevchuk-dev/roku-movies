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