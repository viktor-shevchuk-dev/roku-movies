sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genreMoviesList
  parent = event.parent
  moviesList = event.moviesList
  list = []

  if type(moviesList) = "roAssociativeArray"
    for i = 0 to 19
      item = createObject("roSGNode", "SpecificGenreMovieContent")
      item.loading = moviesList.loading
      item.id = i
      list.push(item)
    end for

    parent.appendChildren(list)
  else if type(moviesList) = "roArray"
    for i = 0 to moviesList.count() - 1
      movie = moviesList[i]
      item = createObject("roSGNode", "SpecificGenreMovieContent")
      item.id = movie.id
      item.title = movie.title
      item.overview = movie.overview
      item.backdropUrl = generateImageUrl(movie.backdrop_path, getDisplaySize().w.toStr(), getDisplaySize().h.toStr())
      item.uri = generateImageUrl(movie.poster_path, "220", "330")
      item.voteAverage = movie.vote_average
      item.streamformat = "mp4"
      item.url = getRandomVideoUrl(m.global.dummyVideosList)
      item.addField("FHDItemWidth", "float", false)
      item.FHDItemWidth = "220"
      item.loading = false
      list.push(item)
    end for

    parent.replaceChildren(list, 0)
  end if
end sub

