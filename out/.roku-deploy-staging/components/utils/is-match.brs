function isMatch(endpoint as dynamic, url as string) as boolean
  ' pattern = endpoint

  ' if type(endpoint) = "roArray"
  '   pattern = ["^"]

  '   for each param in endpoint
  '     condition = "(?=.*\b" + param + "\b)"
  '     pattern.push(condition)
  '   end for

  '   pattern.push(".*$")
  '   pattern = pattern.join("")
  ' end if

  ' return createObject("roRegex", pattern, "i").isMatch(url)

  return createObject("roRegex", endpoint, "i").isMatch(url)
end function

