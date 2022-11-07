sub playButtonClickHandler()
  showNewScreenWithSavingCurrent(m.videoPlayer.id)
  m.videoPlayer.content = m.selectedMovie
  m.videoPlayer.control = "play"
end sub