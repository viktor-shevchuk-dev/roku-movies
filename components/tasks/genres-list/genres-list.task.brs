sub init() as void
  m.top.functionName = "render"
end sub

sub render() as void
  event = m.top.genresList
  genresList = event.genresList
  parent = event.parent
  list = []

  if type(genresList) = "roAssociativeArray"
    for i = 0 to 18
      row = createObject("roSGNode", "Skeleton")
      row.id = i
      row.loading = genresList.loading
      list.push(row)
    end for

    parent.appendChildren(list)
  else if type(genresList) = "roArray"
    for each genre in genresList
      row = createObject("roSGNode", "Skeleton")
      row.title = genre.name
      row.id = genre.id
      row.loading = false
      list.push(row)
    end for
    parent.replaceChildren(list, 0)
    m.top.genresRowsList = parent.getChildren(-1, 0)
  end if
end sub