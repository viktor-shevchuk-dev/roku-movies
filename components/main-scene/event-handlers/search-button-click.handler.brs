sub searchButtonClickHandler()
  searchQuery = m.searchForMoviesScreen.searchQuery
  m.movieListScreen.title = "Searched for " + searchQuery
  searchParamsList = m.movieDB.search.searchParamsList
  searchParamsList.addReplace("query", searchQuery)
  makeRequest({ url: getMovieDBUrl(m.movieDB.search.endpoint, searchParamsList) })
end sub