function itemContentChanged()
  m.itemPoster.uri = m.top.itemContent.HDPOSTERURL
  m.itemTitle.text = m.top.itemContent.title
  setFontSize(m.itemTitle, 28)
end function

function init()
  m.itemPoster = m.top.findNode("itemPoster")
  m.itemTitle = m.top.findNode("itemTitle")
end function