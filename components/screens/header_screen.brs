function changeContent(node, newText)
  node.text = newText
end function

sub onFeedResponse(obj)
  data = obj.getData()
  ? data
  textNode = m.top.findNode("text")
  changeContent(textNode, "lorem")
end sub

function loadText(url)
  m.feed_task = createObject("roSGNode", "load_feed_task")
  m.feed_task.observeField("response", "onFeedResponse")
  m.feed_task.url = url
  m.feed_task.control = "RUN"
end function

sub onButtonSelected(obj)
  data = obj.getData()
  selectedButton = m.button_group.getChild(data)
  identifier = right(selectedButton.text, 1)
  url = m.button_group.baseUrl + identifier
  loadText(url)
end sub

function init()
  m.button_group = m.top.findNode("button_group")
  m.button_group.setFocus(true)
  m.button_group.observeField("buttonSelected", "onButtonSelected")
end function