function isMatch(endpoint as dynamic, url as string) as boolean
  return createObject("roRegex", endpoint, "").isMatch(url)
end function

