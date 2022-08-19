function handleBackButtonClick()
  screenToGo = m.screensHistory.pop()
  if screenToGo = invalid then return false
  screenToGoId = screenToGo.screenId
  screenToGoContent = screenToGo.content

  if m.videoPlayer.visible then stopVideo()

  return showScreen({ screenId: screenToGoId, content: screenToGoContent })
end function