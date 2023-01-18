function observeResponseFromNewUriHandler(obj)
  response = obj.getData()
  parseResponseTask = createObject("roSGNode", "parseResponseTask")
  parseResponseTask.observeField("error", "parseJsonErrorHandler")
  parseResponseTask.observeField("parsedResponse", "parsedResponseHandler")
  parseResponseTask.response = response
  parseResponseTask.control = "run"
end function

function makeRequest(parameters as object)
  context = createObject("roSGNode", "Node")
  context.addFields({ parameters: parameters, response: {} })
  context.observeField("response", "observeResponseFromNewUriHandler")
  m.global.uriHandler.request = { context: context }
end function