sub appendTopRatedMovieToRow(topRatedMovie, row)
  item = row.CreateChild("TopRatedMovieContent")
  item.posterUrl = generateImageUrl(topRatedMovie.poster_path, "200")
  item.title = topRatedMovie.title
  item.releaseDate = topRatedMovie.release_date
  item.id = topRatedMovie.id
  item.additionalInformation = { description: topRatedMovie.overview, backdropUrl: topRatedMovie.backdrop_path, posterUrl: topRatedMovie.poster_path }
end sub

sub showtopRatedMoviesListGrid(content)
  m.top.content = content
end sub

sub onTopRatedMoviesListContentChanged(obj)
  topRatedMoviesList = obj.getData()
  topRatedMoviesListContent = CreateObject("roSGNode", "ContentNode")
  currentTopRatedMovieIndex = 0
  m.top.numRows = topRatedMoviesList.count() / 3

  for numRows = 0 to m.top.numRows
    row = topRatedMoviesListContent.CreateChild("ContentNode")
    row.id = numRows
    for index = 0 to 2
      topRatedMovie = topRatedMoviesList[currentTopRatedMovieIndex]
      if topRatedMovie <> invalid then appendTopRatedMovieToRow(topRatedMovie, row)
      currentTopRatedMovieIndex++
    end for
  end for

  showtopRatedMoviesListGrid(topRatedMoviesListContent)
end sub

