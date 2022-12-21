function handleBackButtonClick()
  screenToGo = m.screensHistory.pop()
  if screenToGo = invalid then return false

  if m.videoPlayer.visible then stopVideo()

  return showScreen({ screenId: screenToGo.screenId, content: screenToGo.content })
end function