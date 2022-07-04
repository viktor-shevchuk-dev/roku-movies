sub onVisibleChange()
  if m.top.visible = true then
    m.headerList.setFocus(true)
  end if
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
end function