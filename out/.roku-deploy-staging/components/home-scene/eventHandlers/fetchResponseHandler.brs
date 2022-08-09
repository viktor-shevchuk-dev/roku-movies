sub fetchResponseHandler (obj)
  response = obj.getData()
  data = ParseJson(response)
  if data = invalid then showErrorDialog("Response is malformed.") else handleData(data)
end sub