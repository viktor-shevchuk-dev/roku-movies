function changeContent(node, newText)
  node.text = newText
end function

function onButtonSelected(obj)
  ? "onButtonSelected field: ";obj.getField()
  changeContent(m.text, "lorem")
end function

function init()
  ? "init button"
  button = m.top.findNode("button")
  buttonrect = button.boundingRect()
  centerx = (1280 - buttonrect.width) / 2
  centery = 30
  button.translation = [centerx, centery]
  button.setFocus(true)
  button.observeField("buttonSelected", "onButtonSelected")
end function