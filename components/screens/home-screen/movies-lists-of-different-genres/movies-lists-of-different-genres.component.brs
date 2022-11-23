sub onGenresListChanged(obj)
  m.genresList = obj.getData()
  content = CreateObject("roSGNode", "ContentNode")
  m.top.content = content
  m.top.numRows = m.genresList.count()

  for each genre in m.genresList
    row = CreateObject("rosgnode", "ContentNode")
    m.top.content.appendChild(row)
  end for

  m.currentGenreIndex = 0
  firtsGenre = m.genresList[m.currentGenreIndex]
  m.top.onFetchSpecificGenreMoviesList = firtsGenre.id
end sub

sub onSpecificGenreMoviesListChanged(obj)
  specificGenreMoviesList = obj.getData()
  currentGenre = m.genresList[m.currentGenreIndex]
  currentRow = CreateObject("rosgnode", "ContentNode")
  currentRow.title = currentGenre.name

  for each movie in specificGenreMoviesList
    item = currentRow.CreateChild("SpecificGenreMovieContent")
    item.title = movie.title
    item.overview = movie.overview
    item.backdropUrl = generateImageUrl(movie.backdrop_path, "200")
    item.posterUrl = generateImageUrl(movie.poster_path, "200")
    item.id = movie.id
    item.streamformat = "mp4"
    item.url = getRandomVideoUrl(m.dummyVideos)
    item.addField("FHDItemWidth", "float", false)
    item.FHDItemWidth = "200"
  end for

  m.top.content.replaceChild(currentRow, m.currentGenreIndex)

  m.currentGenreIndex = m.currentGenreIndex + 1
  nextGenre = m.genresList[m.currentGenreIndex]

  if nextGenre = invalid then return

  m.top.onFetchSpecificGenreMoviesList = nextGenre.id
end sub

function updateDummyVideos(config)
  m.dummyVideos = config.dummyVideos
end function