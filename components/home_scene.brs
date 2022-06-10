function adjustText()
	m.text = m.top.findNode("text")
	textrect = m.text.boundingRect()
	centerx = (1280 - textrect.width) / 2
	centery = (720 - textrect.height) / 2
	m.text.translation = [centerx, centery]
end function

function init()
	? "[home_scene] init"
	m.header_screen = m.top.findNode("header_screen")
	m.header_screen.setFocus(true)
	adjustText()
end function


