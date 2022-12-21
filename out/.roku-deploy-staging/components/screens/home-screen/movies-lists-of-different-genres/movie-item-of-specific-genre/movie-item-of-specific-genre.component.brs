sub itemContentChanged()
  m.poster.uri = m.top.itemContent.posterUrl
end sub

sub init() as void
  m.poster = m.top.findNode("poster")
end sub
