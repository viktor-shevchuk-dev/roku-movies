sub genreTitleHandler(event)
  genreTitle = event.getData()
  animation = m.top.findNode("animation")

  if genreTitle.loading
    animation.control = "start"
  else
    title = genreTitle.title
    label = m.top.findNode("label")
    label.text = title
    skeleton = m.top.findNode("skeleton")
    animation.control = "stop"
    skeleton.visible = false
    label.visible = true
  end if
end sub