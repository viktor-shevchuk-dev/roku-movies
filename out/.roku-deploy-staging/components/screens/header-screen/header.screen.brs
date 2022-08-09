sub onVisibleChange()
  if m.top.visible = true then m.headerList.setFocus(true)
end sub

function init()
  m.headerList = m.top.findNode("headerList")
  m.headerList.itemSize = [296 * 3 + 20 * 2, 90]
  m.headerList.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")
end function

function setHeaderListContent(params)
  baseUrl = params.config.baseUrl
  APIKey = params.config.APIKey
  categories = params.config.categories

  data = CreateObject("roSGNode", "ContentNode")
  row = data.CreateChild("ContentNode")
  for each category in categories
    node = row.CreateChild("HeaderListItemData")
    node.labelText = category.title
    node.id = category.id
    if category.endpoint <> invalid then node.urlToMakeQuery = baseUrl + category.endpoint + APIKey
  end for
  m.headerList.content = data
end function