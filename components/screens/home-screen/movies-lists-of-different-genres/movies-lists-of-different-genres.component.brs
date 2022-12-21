sub onGenresListChanged(obj)
  m.genresList = obj.getData()
  content = createObject("roSGNode", "ContentNode")
  m.top.numRows = m.genresList.count()

  for each genre in m.genresList
    row = createObject("rosgnode", "ContentNode")
    content.appendChild(row)
  end for

  m.top.content = content
  m.currentGenreIndex = 0
end sub

sub onSpecificGenreMoviesListChanged(obj)
  specificGenreMoviesList = obj.getData()

  LoadRowTask = createObject("roSGNode", "MoviesListOfSpecificGenreContent")
  LoadRowTask.content = { moviesList: specificGenreMoviesList, container: m.top.content, rowIndex: m.currentGenreIndex, rowTitle: m.genresList[m.currentGenreIndex].name, dummyVideos: m.dummyVideos }
  LoadRowTask.control = "run"

  m.currentGenreIndex++
end sub

function updateDummyVideos(config)
  m.dummyVideos = config.dummyVideos
end function