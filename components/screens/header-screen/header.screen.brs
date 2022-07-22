sub onVisibleChange()
  if m.top.visible = true then
    m.rowList.setFocus(true)
  end if
end sub

function init()
  m.rowList = m.top.findNode("rowList")
  m.rowList.itemSize = [296 * 3 + 20 * 2, 90]
  m.rowList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
end function

function setRowListContent(params)
  baseUrl = params.config.baseUrl
  APIKey = params.config.APIKey
  categories = params.config.categories

  data = CreateObject("roSGNode", "ContentNode")
  row = data.CreateChild("ContentNode")
  for each category in categories
    node = row.CreateChild("RowListItemData")
    node.labelText = category.title
    node.id = category.id
    if category.endpoint <> invalid
      node.urlToMakeQuery = baseUrl + category.endpoint + APIKey
    end if
  end for
  m.rowList.content = data
end function