sub itemContentChanged()
  itemData = m.top.itemContent
  m.itemText.text = itemData.labelText
end sub

sub init()
  m.itemText = m.top.findNode("itemText")
end sub