sub onVisibleChange()
  if m.top.visible = true then
    m.keyboard.setFocus(true)
  end if
end sub

sub onButtonSelected()
  print m.keyboard.textEditBox.text
end sub

function adjustKeyboard(node)
  node.textEditBox.voiceEnabled = true
  node.setFocus(true)
end function

function adjustSearchButton(node)
  node.observeField("buttonSelected", "onButtonSelected")
  parent = node.getParent()
  parentRect = parent.boundingRect()
  x = parentRect.width
  y = node.translation[1]
  node.translation = [x, y]
end function

function init()
  m.heading = m.top.findNode("heading")
  m.keyboard = m.top.findNode("keyboard")
  m.searchButton = m.top.findNode("searchButton")
  m.input = m.top.findNode("input")

  adjustHeading(m.heading)
  adjustKeyboard(m.keyboard)
  adjustSearchButton(m.searchButton)
  center(m.input)
  m.top.observeField("visible", "onVisibleChange")
end function

function handleRightClick()
  m.searchButton.setFocus(true)
  return true
end function

function handleLeftClick()
  m.keyboard.setFocus(true)
  return true
end function

function onKeyEvent(key, press) as boolean
  if key = "right"
    return handleRightClick()
  end if
  if key = "left" and m.searchButton.hasFocus()
    return handleLeftClick()
  end if

  return false

end function