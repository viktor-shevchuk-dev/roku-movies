' create a separate task for this
' when I got a list of all genres - via for loop call onSpecificGenreMoviesListChanged and pass there moviesList with skeleton objects. "for each movie in emptyRow.moviesList - item.id make a check - if false, then - createChild("skeleton")"

sub handleGenresRowsList(event)
  genresRowsList = event.getData()

  for each genreRow in genresRowsList
    genreMoviesListTask = createObject("roSGNode", "GenreMoviesListTask")
    genreMoviesListTask.genreMoviesList = {
      moviesList: { loading: true },
      parent: genreRow,
    }
    genreMoviesListTask.control = "run"
  end for
end sub

sub genresListHandler(event)
  genresList = event.getData()
  numRows = genresList.count()
  m.top.numRows = numRows
  content = m.top.content
  genresListTask = createObject("roSGNode", "GenresListTask")
  genresListTask.observeField("genresRowsList", "handleGenresRowsList")
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
  genreMoviesListTask = createObject("roSGNode", "GenreMoviesListTask")
  genreMoviesListTask.genreMoviesList = {
    parent: m.top.content.getChild(num),
    moviesList: moviesList,
  }
  genreMoviesListTask.control = "run"
end sub
