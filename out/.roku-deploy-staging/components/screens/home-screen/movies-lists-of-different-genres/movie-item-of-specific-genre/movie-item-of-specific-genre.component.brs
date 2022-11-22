function itemContentChanged() as void
  itemData = m.top.itemContent
  m.topRatedMoviePoster.uri = itemData.posterUrl
  ' m.topRatedMovieTitle.text = itemData.title
  ' m.topRatedMovieReleaseDate.text = itemData.releaseDate
  ' setFontSize(m.topRatedMovieTitle, 25)
  ' setFontSize(m.topRatedMovieReleaseDate, 25)
end function

function init() as void
  m.topRatedMoviePoster = m.top.findNode("topRatedMoviePoster")
  ' m.topRatedMovieTitle = m.top.findNode("topRatedMovieTitle")
  ' m.topRatedMovieReleaseDate = m.top.findNode("topRatedMovieReleaseDate")
end function