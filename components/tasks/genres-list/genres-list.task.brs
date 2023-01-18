sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genresList
  genresList = event.genresList
  parent = event.parent

  for each genre in genresList
    row = parent.createChild("ContentNode")
    row.title = genre.name
    row.id = genre.id
  end for
end sub