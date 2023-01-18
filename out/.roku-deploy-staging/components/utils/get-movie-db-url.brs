function getMovieDBUrl(endpoint as string, searchParams = invalid as dynamic) as string
  url = [m.global.movieDB.baseUrl]
  pathParam = "{movie_id}"
  isPathParamBetween = isMatch(pathParam, endpoint)
  params = { language: "en-US", include_adult: "false" }

  if isPathParamBetween
    r = createObject("roRegex", pathParam, "")
    url.push(r.replace(endpoint, searchParams.toStr()))
  else
    url.push(endpoint)
  end if

  if type(searchParams) = "roAssociativeArray"
    params.append(searchParams)
  else if type(searchParams) = "roInt" and not isPathParamBetween
    url.push("/" + searchParams.toStr())
  end if

  url.push(m.global.movieDB.APIKey)
  url.push("&page=1")

  for each key in params.keys()
    searchParam = substitute("&{0}={1}", key, params[key].toStr())
    url.push(searchParam)
  end for

  return url.join("")
end function