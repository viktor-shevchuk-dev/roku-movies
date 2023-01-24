sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genresList
  genresList = event.genresList
  parent = event.parent
  list = []

  for each genre in genresList
    row = createObject("roSGNode", "ContentNode")
    row.title = genre.name
    row.id = genre.id
    list.push(row)
  end for

  parent.appendChildren(list)
  m.top.genresRowsList = parent.getChildren(-1, 0)
end sub