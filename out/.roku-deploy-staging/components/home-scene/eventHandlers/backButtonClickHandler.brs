function handleBackButtonClickFromVideoPlayer(screenToGoId, screenToGoContent)
  stopVideo()

  return showScreen({ screenId: screenToGoId, content: screenToGoContent })
end function

function handleBackButtonClick()
  screenToGo = m.screensHistory.pop()
  if screenToGo = invalid then return false
  screenToGoId = screenToGo.screenId
  screenToGoContent = screenToGo.content

  if m.videoPlayer.visible then return handleBackButtonClickFromVideoPlayer(screenToGoId, screenToGoContent) else return showScreen({ screenId: screenToGoId, content: screenToGoContent })

  return false
end function