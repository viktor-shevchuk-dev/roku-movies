sub init()
  m.top.functionName = "parse"
  m.top.parsedResponse = invalid
end sub

function parse()
  response = m.top.response
  isInvalidResponse = response = invalid or type(response) <> "roAssociativeArray"
  if isInvalidResponse then m.top.error = "Response is invalid."
  json = response.content
  num = response.num
  isNotProvidedJson = json = "" or json = invalid
  if isNotProvidedJson then m.top.error = "Json string not provided."

  content = ParseJson(json)

  if content = invalid then m.top.error = "Json is malformed."
  response.content = content
  m.top.parsedResponse = response
end function