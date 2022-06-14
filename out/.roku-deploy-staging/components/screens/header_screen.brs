sub onVisibleChange()
STOP
  ? "onVisibleChange header_screen"
  if m.top.visible = true then
    m.button_group.setFocus(true)
  end if
end sub

sub init()
  m.button_group = m.top.findNode("button_group")
  m.button_group.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
end sub