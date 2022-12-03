sub init()
  m.top.functionName = "parse"
  m.top.parsedJson = invalid
end sub

function parse()
  if m.top.json = "" or m.top.json = invalid then m.top.error = "Json string not provided."

  parsedJson = ParseJson(m.top.json)

  if parsedJson = invalid then m.top.error = "Json is malformed." else m.top.parsedJson = parsedJson
end function