sub additionalInformationClickHandler(obj)
  list = m.detailsScreen.findNode("additionalInformationList")
  index = obj.getData()[1]
  category = list.content.getChild(0).getChild(index)
  castUrl = getMovieDBUrl(category.endpoint, m.movieId)
  makeRequest({ url: castUrl })
end sub