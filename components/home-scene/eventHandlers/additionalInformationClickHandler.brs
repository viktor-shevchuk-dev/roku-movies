sub additionalInformationClickHandler(obj)
  list = m.detailsScreen.findNode("additionalInformationList")
  index = obj.getData()[1]
  category = list.content.getChild(0).getChild(index)
  url = m.baseUrl + "/movie/" + m.movieId.toStr() + category.urlToMakeQuery + m.APIKey + "&language=en-US"
  fetch(url)
end sub