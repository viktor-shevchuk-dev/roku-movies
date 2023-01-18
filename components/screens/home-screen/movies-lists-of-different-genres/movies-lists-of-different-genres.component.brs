' create a separate task for this
' when I got a list of all genres - via for loop call onSpecificGenreMoviesListChanged and pass there moviesList with skeleton objects. "for each movie in emptyRow.moviesList - item.id make a check - if false, then - createChild("skeleton")"

sub genresListHandler(event)
  genresList = event.getData()
  numRows = genresList.count()
  m.top.numRows = numRows
  m.top.content = createObject("roSGNode", "ContentNode")
  content = m.top.content
  content.id = "genresMoviesListContent"
  genresListTask = createObject("roSGNode", "GenresListTask")
  genresListTask.genresList = {
    genresList: genresList
    parent: content
  }
  genresListTask.control = "run"

  for i = 0 to numRows - 1
    genre = genresList[i]
    searchParamsList = m.global.movieDB.endpointsList.genreMoviesList.searchParamsList
    key = searchParamsList.keys()[1]
    searchParamsList.addReplace(key, genre.id)
    genreMoviesListUrl = getMovieDBUrl(m.global.movieDB.endpointsList.genreMoviesList.endpoint, searchParamsList)
    m.top.genreMoviesListParameters = {
      url: genreMoviesListUrl,
      num: i
    }
  end for
end sub

sub onSpecificGenreMoviesListChanged(obj)
  specificGenreMoviesList = obj.getData()
  moviesList = specificGenreMoviesList.moviesList
  num = specificGenreMoviesList.num
  LoadRowTask = createObject("roSGNode", "GenreMoviesListTask")
  LoadRowTask.genreMoviesList = {
    parent: m.top.content.getChild(num),
    moviesList: moviesList,
  }
  LoadRowTask.control = "run"
end sub
