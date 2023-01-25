sub itemContentChangeHandler()
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

    if m.top.itemHasFocus
      rowList = m.top.getParent().getParent().getParent()
      rowList.jumpToRowItem = rowList.rowItemFocused
    end if
  end if
end sub