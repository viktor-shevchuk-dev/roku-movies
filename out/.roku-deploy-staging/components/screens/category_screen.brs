function updateConfig(params)
  config = params.config
  categories = config.categories
  host = config.host

  ' contentNode = CreateObject("roSGNode", "ContentNode")
  ' for each category in categories
  '   node = CreateObject("roSGNode", "category_node")
  '   node.text = category.title
  '   node.feed_url = host + category.feed_url
  '   contentNode.appendChild(node)
  ' end for
  ' m.category_list.content = contentNode

  for each category in categories
    button = CreateObject("roSGNode", "category_node")
    button.text = category.title
    button.feed_url = host + category.feed_url
    m.category_list.appendChild(button)
  end for
end function

sub onVisibleChange()
  if m.top.visible = true then
    m.category_list.setFocus(true)
  end if
end sub

function init()
  m.category_list = m.top.findNode("category_list")
  m.category_list.setFocus(true)
  m.top.observeField("visible", "onVisibleChange")

  button = CreateObject("roAssociativeArray")
end function

