sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genreMoviesList
  parent = event.parent
  moviesList = event.moviesList

  if type(moviesList) = "roAssociativeArray"
    list = []

    for i = 0 to 19
      item = createObject("roSGNode", "SpecificGenreMovieContent")
      item.loading = moviesList.loading
      list.push(item)
    end for

    parent.appendChildren(list)
  else if type(moviesList) = "roArray"
    list = []

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
    rowList = parent.getParent().getParent()
    rowItemFocused = rowList.rowItemFocused

    if rowItemFocused.count()
      rowList.jumpToRowItem = rowItemFocused
    end if
  end if
end sub

