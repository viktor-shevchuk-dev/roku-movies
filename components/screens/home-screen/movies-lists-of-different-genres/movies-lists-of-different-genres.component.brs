sub onGenresListChanged(obj)
  m.genresList = obj.getData()
  content = CreateObject("roSGNode", "ContentNode")
  m.top.numRows = m.genresList.count()

  for each genre in m.genresList
    row = CreateObject("rosgnode", "ContentNode")
    content.appendChild(row)
  end for

  m.top.content = content
  m.currentGenreIndex = 0
  firtsGenre = m.genresList[m.currentGenreIndex]
  m.top.onFetchSpecificGenreMoviesList = firtsGenre.id
end sub

sub onSpecificGenreMoviesListChanged(obj)
  specificGenreMoviesList = obj.getData()
  LoadRowTask = createObject("roSGNode", "MoviesListOfSpecificGenreContent")
  LoadRowTask.moviesList = specificGenreMoviesList
  LoadRowTask.content = m.top.content
  LoadRowTask.rowIndex = m.currentGenreIndex
  LoadRowTask.rowTitle = m.genresList[m.currentGenreIndex].name
  LoadRowTask.dummyVideos = m.dummyVideos
  LoadRowTask.control = "run"

  m.currentGenreIndex++
  nextGenre = m.genresList[m.currentGenreIndex]

  if nextGenre = invalid then return

  m.top.onFetchSpecificGenreMoviesList = nextGenre.id
end sub

function updateDummyVideos(config)
  m.dummyVideos = config.dummyVideos
end function