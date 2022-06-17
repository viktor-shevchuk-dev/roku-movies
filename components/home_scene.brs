sub onFeedResponse(obj)
	response = obj.getData()
	data = ParseJson(response)
	if data <> invalid and data.items <> invalid
		m.category_screen.visible = false
		m.content_screen.visible = true
		m.content_screen.feed_data = data
	else
		? "FEED RESPONSE IS EMPTY"
	end if
end sub

sub loadFeed(url)
	m.feed_task = CreateObject("roSGNode", "load_feed_task")
	m.feed_task.observeField("response", "onFeedResponse")
	m.feed_task.url = url
	m.feed_task.control = "RUN"
end sub

sub onCategorySelected(obj)
	list = m.category_screen.findNode("category_list")
	' item = obj.getRoSGNode().content.getChild(obj.getData())
	index = obj.getData()
	item = list.getChild(index)
	loadFeed(item.feed_url)
end sub

function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")

	m.category_screen.observeField("category_selected", "onCategorySelected")
	m.category_screen.setFocus(true)
end function

function onKeyEvent(key, press) as boolean
	? "[home_scene] onKeyEvent", key, press
	if key = "back" and press
		if m.content_screen.visible
			m.content_screen.visible = false
			m.category_screen.visible = true
			m.category_screen.setFocus(true)
			return true
		end if
	end if
	return false
end function