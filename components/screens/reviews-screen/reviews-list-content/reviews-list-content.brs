function deleteFirstCharacter(string)
  return string.mid(1)
end function

function createImageUrl(path)
  if path = invalid then return ""

  pathIncludesGravatar = path.Instr("gravatar") >= 0
  if pathIncludesGravatar
    firstCharacter = path.left(1)
    if firstCharacter = "/" then return deleteFirstCharacter(path)

    return path
  end if

  return generateImageUrl(path, "220", "330")
end function

sub init()
  m.reviewsWrapper = m.top.findNode("reviewsWrapper")
end sub

sub onReviewsChanged(obj)
  reviews = obj.getData()
  for each review in reviews
    node = createObject("roSGNode", "ContentNode")
    node.id = review.id
    node.HDPosterUrl = createImageUrl(review.author_details.avatar_path)
    node.title = review.author
    node.description = review.content
    m.reviewsWrapper.appendChild(node)
  end for
end sub

