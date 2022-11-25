function getItemFromRowList(rowListNode, eventType)
  indexesList = invalid
  if eventType = "focus"
    indexesList = rowListNode.rowItemFocused
  else if eventType = "click"
    indexesList = rowListNode.rowItemSelected
  end if

  rowIndex = indexesList[0]
  colIndex = indexesList[1]
  row = rowListNode.content.getChild(rowIndex)
  item = row.getChild(colIndex)

  return item
end function