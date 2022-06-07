function changeContent(node, newText)
  node.text = newText
end function

function onButtonSelected(obj)
  ? "onButtonSelected field: ";obj.getField()
  changeContent(m.text, "lorem")
end function

function adjustButton()
  button = m.top.findNode("button")
  buttonrect = button.boundingRect()
  centerx = (1280 - buttonrect.width) / 2
  centery = 30
  button.translation = [centerx, centery]
  button.setFocus(true)
  button.observeField("buttonSelected", "onButtonSelected")
end function

function adjustText()
  m.text = m.top.findNode("text")
  textrect = m.text.boundingRect()
  centerx = (1280 - textrect.width) / 2
  centery = (720 - textrect.height) / 2
  m.text.translation = [centerx, centery]
end function

function init()
  ? "[home_scene] init"
  m.top.backgroundURI = "pkg:/images/rsgde_bg_hd.jpg"
  adjustText()
  adjustButton()
end function

function onKeyEvent(key, press) as boolean
  ? "click"
  return false
end function
