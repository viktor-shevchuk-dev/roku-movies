sub itemContentChanged()
  animation = m.top.findNode("animation")

  if m.top.itemContent.loading
    animation.control = "start"
  else
    poster = m.top.findNode("poster")
    poster.uri = m.top.itemContent.uri
    skeleton = m.top.findNode("skeleton")
    animation.control = "stop"
    skeleton.visible = false
    poster.visible = true
  end if
end sub
