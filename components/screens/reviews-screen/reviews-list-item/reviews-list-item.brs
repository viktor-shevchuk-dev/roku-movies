
sub init()
  m.itemposter = m.top.findNode("itemPoster")
  m.author = m.top.findNode("author")
  m.review = m.top.findNode("review")
  m.itemmask = m.top.findNode("itemMask")

end sub

sub showcontent()
  itemcontent = m.top.itemContent
  m.itemposter.uri = itemcontent.HDPosterUrl
  m.author.text = itemcontent.title
  m.review.text = itemcontent.description
end sub

sub showfocus()
  scale = 1 + (m.top.focusPercent * 0.08)
  m.itemposter.scale = [scale, scale]
end sub
