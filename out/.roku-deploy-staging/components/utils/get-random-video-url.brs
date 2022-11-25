function getRandomVideoUrl(videosList)
  dummyVideosCount = videosList.count()
  url = videosList[RND(dummyVideosCount)]

  return url
end function