sub onConfigResponse(obj)
	response = obj.getData()
	data = ParseJson(response)
	if data <> invalid
		params = { config: data }
		m.category_screen.callFunc("updateConfig", params)
	else
		showErrorDialog("Sth went wrong. Please try again later.")
	end if
end sub

sub showErrorDialog(message)
	m.error_dialog.title = "ERROR"
	m.error_dialog.message = message
	m.error_dialog.visible = true
	m.top.dialog = m.error_dialog
end sub

sub closeVideo()
	m.videoplayer.control = "stop"
	m.videoplayer.visible = false
	m.details_screen.visible = true
end sub

sub onPlayerPositionChanged(obj)
	? "Player Position: ", obj.getData()
end sub

sub onPlayerStateChanged(obj)
	state = obj.getData()
	? "onPlayerStateChanged: "; state
	if state = "error"
		errorCode = m.videoplayer.errorCode
		errorMessage = m.videoplayer.errorMsg
		messageForErrorDialog = errorMessage + chr(10) + "Error Code: " + errorCode.toStr()
		showErrorDialog(messageForErrorDialog)
	else if state = "finished"
		closeVideo()
	end if
end sub

sub initializeVideoPlayer()
	m.videoplayer.EnableCookies()
	m.videoplayer.setCertificatesFile("common:/certs/ca-bundle.crt")
	m.videoplayer.InitClientCertificates()
	m.videoplayer.notificationInterval = 1
	m.videoplayer.observeFieldScoped("position", "onPlayerPositionChanged")
	m.videoplayer.observeFieldScoped("state", "onPlayerStateChanged")
end sub

sub onFeedResponse(obj)
	response = obj.getData()
	data = ParseJson(response)
	if data <> invalid and data.items <> invalid
		m.category_screen.visible = false
		m.content_screen.visible = true
		m.content_screen.feed_data = data
	else
		? "RESPONSE IS EMPTY"
		showErrorDialog("Feed data malformed.")
	end if
end sub

sub loadFeedJson(url)
	loadJson(url)
	m.json_task.observeField("response", "onFeedResponse")
end sub

sub onCategorySelected(obj)
	list = m.category_screen.findNode("category_list")
	' item = obj.getRoSGNode().content.getChild(obj.getData())
	selected_index = obj.getData()
	item = list.getChild(selected_index)
STOP
	loadFeedJson(item.feed_url)
end sub

sub onContentSelected(obj)
	selected_index = obj.getData()
	m.selected_media = m.content_screen.findNode("content_grid").content.getChild(selected_index)
	m.details_screen.content = m.selected_media
	m.content_screen.visible = false
	m.details_screen.visible = true
end sub

sub onPlayButtonPressed(obj)
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
	m.videoplayer.content = m.selected_media
	m.videoplayer.control = "play"
end sub

sub onFeedError(obj)
	showErrorDialog(obj.getData())
end sub

sub loadJson(url)
	m.json_task = CreateObject("roSGNode", "load_json")
	m.json_task.observeField("error", "onFeedError")
	m.json_task.url = url
	m.json_task.control = "RUN"
end sub

sub loadConfig(url)
	loadJson(url)
	m.json_task.observeField("response", "onConfigResponse")
end sub

function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.videoplayer = m.top.findNode("videoplayer")
	m.error_dialog = m.top.findNode("error_dialog")

	initializeVideoPlayer()

	m.category_screen.observeField("category_selected", "onCategorySelected")
	m.content_screen.observeField("content_selected", "onContentSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")

	m.category_screen.setFocus(true)

	loadConfig("https://run.mocky.io/v3/521ee927-5b4d-41d9-86af-84f2a0564688")
end function

function onKeyEvent(key, press) as boolean
	? "[home_scene] onKeyEvent", key, press

	if key = "back" and press
		if m.content_screen.visible
			m.content_screen.visible = false
			m.category_screen.visible = true
			m.category_screen.setFocus(true)
			return true
		else if m.details_screen.visible
			m.details_screen.visible = false
			m.content_screen.visible = true
			m.content_screen.setFocus(true)
			return true
		else if m.videoplayer.visible
			closeVideo()
			m.details_screen.setFocus(true)
			return true
		end if
	end if
	return false
end function