function itemContentChanged()
  itemData = m.top.itemContent
  m.itemText.text = itemData.labelText
end function

function init()
  m.itemText = m.top.findNode("itemText")
end function