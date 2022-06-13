sub onFeedResponse(obj)
  response = obj.getData()
  data = ParseJson(response)
  if data <> invalid
    ' m.header_screen.visible = false
    m.content_screen.visible = true
    color = m.selectedButtonText.replace("cat", "").trim()

    for each item in data
      if item.color = color
        m.content_screen.feed_data = item

        return
      end if
    end for
  else
    ? "FEED RESPONSE IS EMPTY!"
  end if
end sub

function loadText(url)
  m.feed_task = createObject("roSGNode", "load_feed_task")
  m.feed_task.observeField("response", "onFeedResponse")
  m.feed_task.url = url
  m.feed_task.control = "RUN"
end function

sub onButtonSelected(obj)
  m.buttonIndex = obj.getData()
  selectedButton = m.button_group.getChild(m.buttonIndex)
  m.selectedButtonText = selectedButton.text
  loadText(m.button_group.baseUrl)
end sub

function init()
  ? "[home_scene] init"
  m.header_screen = m.top.findNode("header_screen")
  m.content_screen = m.top.findNode("content_screen")
  m.button_group = m.top.findNode("button_group")

  m.header_screen.observeField("button_selected", "onButtonSelected")
  m.header_screen.setFocus(true)
end function


