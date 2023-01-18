sub searchButtonClickHandler()
  searchQuery = m.searchForMoviesScreen.searchQuery
  m.movieListScreen.title = "Searched for " + searchQuery
  searchParamsList = m.global.movieDB.endpointsList.search.searchParamsList
  key = searchParamsList.keys()[0]
  searchParamsList.addReplace(key, searchQuery)
  makeRequest({ url: getMovieDBUrl(m.global.movieDB.endpointsList.search.endpoint, searchParamsList) })
end sub