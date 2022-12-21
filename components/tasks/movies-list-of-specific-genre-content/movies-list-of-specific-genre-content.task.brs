sub init()
  m.top.functionName = "loadContent"
end sub

sub loadContent()
  content = m.top.content
  container = content.container
  moviesList = content.moviesList
  rowIndex = content.rowIndex
  rowTitle = content.rowTitle
  dummyVideos = content.dummyVideos

  if moviesList = invalid or content = invalid or rowIndex = invalid or rowTitle = invalid or dummyVideos = invalid then return

  row = createObject("rosgnode", "ContentNode")
  row.title = rowTitle

  for each movie in moviesList
    item = row.createChild("SpecificGenreMovieContent")
    item.id = movie.id
    item.title = movie.title
    item.overview = movie.overview
    item.backdropUrl = generateImageUrl(movie.backdrop_path, getDisplaySize().w.toStr(), getDisplaySize().h.toStr())
    item.posterUrl = generateImageUrl(movie.poster_path, "220", "330")
    item.voteAverage = movie.vote_average
    item.streamformat = "mp4"
    item.url = getRandomVideoUrl(dummyVideos)
    item.addField("FHDItemWidth", "float", false)
    item.FHDItemWidth = "220"
  end for

  container.replaceChild(row, rowIndex)
end sub
