sub fetchResponseHandler (obj)
  response = obj.getData()
  m.parseJsonTask = CreateObject("roSGNode", "parseJsonTask")
  m.parseJsonTask.observeField("error", "parseJsonErrorHandler")
  m.parseJsonTask.observeField("parsedJson", "parsedJsonHandler")
  m.parseJsonTask.json = response
  m.parseJsonTask.control = "run"
end sub