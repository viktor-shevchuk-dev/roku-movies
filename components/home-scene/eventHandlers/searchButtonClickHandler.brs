sub searchButtonClickHandler()
  searchQuery = m.searchForMoviesScreen.searchQuery
  m.movieListScreen.title = "Searched for " + searchQuery
  url = m.baseUrl + "/search/movie" + m.APIKey + "&language=en-US&page=1&include_adult=false&query=" + searchQuery
  fetch(url)
end sub