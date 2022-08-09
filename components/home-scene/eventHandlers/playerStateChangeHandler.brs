sub playerStateChangeHandler(obj)
  state = obj.getData()
  ? "playerStateChangeHandler: ";state
  if state = "error"
    showErrorDialog(m.videoPlayer.errorMsg + chr(10) + "Error Code: " + m.videoPlayer.errorCode.toStr())
  else if state = "finished"
    stopVideo()
    showNewScreenWithSavingCurrent(m.detailsScreen.id)
  end if
end sub