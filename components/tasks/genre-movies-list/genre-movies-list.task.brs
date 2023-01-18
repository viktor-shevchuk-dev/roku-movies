sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genreMoviesList
  parent = event.parent
  moviesList = event.moviesList

  for each movie in moviesList
    item = parent.createChild("SpecificGenreMovieContent")
    item.id = movie.id
    item.title = movie.title
    item.overview = movie.overview
    item.backdropUrl = generateImageUrl(movie.backdrop_path, getDisplaySize().w.toStr(), getDisplaySize().h.toStr())
    item.posterUrl = generateImageUrl(movie.poster_path, "220", "330")
    item.voteAverage = movie.vote_average
    item.streamformat = "mp4"
    item.url = getRandomVideoUrl(m.global.dummyVideosList)
    item.addField("FHDItemWidth", "float", false)
    item.FHDItemWidth = "220"
  end for
end sub

