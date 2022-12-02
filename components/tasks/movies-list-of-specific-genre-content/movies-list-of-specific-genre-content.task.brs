sub init()
  m.top.functionName = "loadContent"
end sub

sub loadContent()
  moviesList = m.top.moviesList
  content = m.top.content
  rowIndex = m.top.rowIndex
  rowTitle = m.top.rowTitle
  dummyVideos = m.top.dummyVideos

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

  content.replaceChild(row, rowIndex)
end sub
