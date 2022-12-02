sub onVisibleChange()
  if m.top.visible = true then m.peopleGrid.setFocus(true)
end sub

sub init()
  m.peopleGrid = m.top.FindNode("peopleGrid")
  m.heading = m.top.FindNode("heading")
  m.top.observeField("visible", "onVisibleChange")
end sub

sub appendKnownForMoviesList(node, knownForMoviesList)
  knowForMoviesTitlesList = []
  for each movie in knownForMoviesList
    knowForMoviesTitlesList.push(movie.title)
  end for
  node.SHORTDESCRIPTIONLINE2 = knowForMoviesTitlesList.join(", ")
end sub

sub onCastChanged(obj)
  people = obj.getData()
  m.heading.text = people.title
  adjustHeading(m.heading)

  posterContent = createObject("roSGNode", "ContentNode")
  for each person in people.peopleList
    node = createObject("roSGNode", "ContentNode")
    node.id = person.id
    node.HDGRIDPOSTERURL = generateImageUrl(person.profile_path, "300", "450")
    node.SHORTDESCRIPTIONLINE1 = person.name
    appendKnownForMoviesList(node, person.known_for)
    if person.character <> invalid then node.SHORTDESCRIPTIONLINE2 = "Character: " + person.character
    posterContent.appendChild(node)
  end for
  showPosterGrid(posterContent)
end sub

sub showPosterGrid(content)
  m.peopleGrid.content = content
  m.peopleGrid.visible = true
  m.peopleGrid.setFocus(true)
end sub