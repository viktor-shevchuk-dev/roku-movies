sub itemContentChanged()
  poster = m.top.findNode("poster")
  animation = m.top.findNode("animation")

  if m.top.itemContent.loading
    animation.control = "start"
  else
    poster.uri = m.top.itemContent.uri
    skeleton = m.top.findNode("skeleton")
    animation.control = "stop"
    skeleton.visible = false
    poster.visible = true
  end if
end sub

sub init() as void
  ' fix that fact that after clicking on home - ten second pass before it navigates to the home screen. Check whether home screen opens immediately and does not wait for movies to load

end sub
