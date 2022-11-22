sub onGenresListChanged(obj)
  m.genresList = obj.getData()
  content = CreateObject("roSGNode", "ContentNode")
  m.top.content = content
  m.currentGenreIndex = 0
  firtsGenre = m.genresList[m.currentGenreIndex]
  m.top.onFetchSpecificGenreMoviesList = firtsGenre.id
end sub

sub onSpecificGenreMoviesListChanged(obj)
  specificGenreMoviesList = obj.getData()
  row = CreateObject("rosgnode", "ContentNode")
  currentGenre = m.genresList[m.currentGenreIndex]
  row.title = currentGenre.name


  m.top.content.appendChild(row)

  for each movie in specificGenreMoviesList
    item = row.CreateChild("SpecificGenreMovieContent")
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

  m.currentGenreIndex = m.currentGenreIndex + 1
  nextGenre = m.genresList[m.currentGenreIndex]

  if nextGenre = invalid then return

  m.top.onFetchSpecificGenreMoviesList = nextGenre.id
end sub

function updateDummyVideos(config)
  m.dummyVideos = config.dummyVideos
end function