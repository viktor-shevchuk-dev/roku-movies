sub init()
  print "Parser.brs - [init]"
end sub

' Parses the response string as XML
' The parsing logic will be different for different RSS feeds
sub parseResponse()
  json = m.top.response.content
  num = m.top.response.num
  title = m.top.response.parameters.title

  movies = ParseJson(json)

  result = []

  for each movie in movies.results
    item = {}
    item.id = movie.id
    item.title = movie.title
    item.overview = movie.overview
    item.backdropUrl = generateImageUrl(movie.backdrop_path, getDisplaySize().w.toStr(), getDisplaySize().h.toStr())
    item.posterUrl = generateImageUrl(movie.poster_path, "220", "330")
    item.voteAverage = movie.vote_average
    item.streamformat = "mp4"
    item.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    ' item.addField("FHDItemWidth", "float", false)
    ' item.FHDItemWidth = "220"

    result.push(item)
  end for

  contentObject = {}

  content = createRow(title, result)

  'Add the newly parsed content row to the cache until everything is ready
  if content <> invalid
    contentObject[num.toStr()] = content
    if m.UriHandler = invalid then m.UriHandler = m.top.getParent()
    m.UriHandler.contentCache.addFields(contentObject)
  else
    print "Error: content was invalid"
  end if
end sub

function AddAndSetFields(node as object, movie as object)
  addFields = {}
  setFields = {}
  for each field in movie
    if node.hasField(field)
      setFields[field] = movie[field]
    else
      addFields[field] = movie[field]
    end if
  end for
  node.setFields(setFields)
  node.addFields(addFields)
end function

function createRow(title as string, list as object)
  parent = createObject("RoSGNode", "ContentNode")
  row = createObject("RoSGNode", "ContentNode")
  row.Title = title
  for each movie in list
    itemNode = createObject("RoSGNode", "ContentNode")
    AddAndSetFields(itemNode, movie)
    row.appendChild(itemNode)
  end for
  parent.appendChild(row)

  return parent
end function

