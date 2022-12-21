sub init()
  m.top.functionName = "parse"
  m.top.parsedResponse = invalid
end sub

function parse()
  if m.top.response = invalid then m.top.error = "Response is invalid."
  json = m.top.response.content
  if json = "" or json = invalid then m.top.error = "Json string not provided."

  parsedJson = ParseJson(json)

  if parsedJson = invalid then m.top.error = "Json is malformed."

  parsedResponse = m.top.response
  parsedResponse.content = parsedJson
  m.top.parsedResponse = parsedResponse
end function