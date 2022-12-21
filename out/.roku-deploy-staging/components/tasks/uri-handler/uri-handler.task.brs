' A context node has a parameters and response field
' - parameters corresponds to everything related to an HTTP request
' - response corresponds to everything related to an HTTP response
' Component Variables:
'   m.port: the UriFetcher message port
'   m.jobsById: an AA containing a history of HTTP requests/responses

' init(): UriFetcher constructor
' Description: sets the execution function for the UriFetcher
' 						 and tells the UriFetcher to run
sub init()
  print "UriHandler.brs - [init]"

  ' create the message port
  m.port = createObject("roMessagePort")

  ' fields for checking if content has been loaded
  ' each row is assumed to be a different request for a rss feed
  m.top.numRows = 19
  m.top.numRowsReceived = 0
  m.top.numBadRequests = 0
  m.top.contentSet = false

  ' Stores the content if not all requests are ready
  m.top.ContentCache = createObject("roSGNode", "ContentNode")

  ' setting callbacks for url request and response
  m.top.observeField("request", m.port)
  m.top.observeField("ContentCache", m.port)

  ' setting the task thread function
  m.top.functionName = "go"
  m.top.control = "RUN"
end sub

' Callback function for when content has finished parsing
sub updateContent()
  ' Received another row of content
  m.top.numRowsReceived++

  ' Return if the content is already set
  if m.top.contentSet return
  ' Set the UI if all content from all streams are ready
  ' Note: this technique is hindered by slowest request
  ' Need to think of a better asynchronous method here!
  if m.top.numRows <> m.top.numRowsReceived return

  parent = createObject("roSGNode", "ContentNode")
  for i = 0 to (m.top.numRowsReceived - 1)
    oldParent = m.top.contentCache.getField(i.toStr())
    if oldParent <> invalid
      for j = 0 to (oldParent.getChildCount() - 1)
        oldParent.getChild(0).reparent(parent, true)
      end for
    end if
  end for
  m.top.contentSet = true
  m.top.content = parent
end sub

' go(): The "Task" function.
'   Has an event loop which calls the appropriate functions for
'   handling requests made by the HeroScreen and responses when requests are finished
' variables:
'   m.jobsById: AA storing HTTP transactions where:
'			key: id of HTTP request
'  		val: an AA containing:
'       - key: context
'         val: a node containing request info
'       - key: xfer
'         val: the roUrlTransfer object
sub go()
  ' Holds requests by id
  m.jobsById = {}

  ' UriFetcher event loop
  while true
    msg = wait(0, m.port)
    mt = type(msg)
    print "Received event type '"; mt; "'"
    ' If a request was made
    if mt = "roSGNodeEvent"
      if msg.getField() = "request"
        if addRequest(msg.getData()) <> true then print "Invalid request"
      else if msg.getField() = "ContentCache"
        updateContent()
      else
        print "Error: unrecognized field '"; msg.getField() ; "'"
      end if
      ' If a response was received
    else if mt = "roUrlEvent"
      processResponse(msg)
      ' Handle unexpected cases
    else
      print "Error: unrecognized event type '"; mt ; "'"
    end if
  end while
end sub

' addRequest():
'   Makes the HTTP request
' parameters:
'		request: a node containing the request params/context.
' variables:
'   m.jobsById: used to store a history of HTTP requests
' return value:
'   True if request succeeds
' 	False if invalid request
function addRequest(request as object) as boolean
  ' context = request.context
  ' parser = request.parser

  ' if m.Parser = invalid
  '   m.Parser = createObject("roSGNode", parser)
  '   m.Parser.observeField("parsedContent", m.port)
  ' else
  '   print "Parser already created"
  ' end if

  url = request.context.parameters.url

  if type(url) = "roString"
    urlXfer = createObject("roUrlTransfer")
    urlXfer.setCertificatesFile("common:/certs/ca-bundle.crt")
    urlXfer.setUrl(url)
    urlXfer.setPort(m.port)
    ' should transfer more stuff from parameters to urlXfer
    idKey = stri(urlXfer.getIdentity()).trim()
    ' AsyncGetToString returns false if the request couldn't be issued
    ok = urlXfer.AsyncGetToString()
    if ok then
      m.jobsById[idKey] = {
        context: request,
        xfer: urlXfer
      }
    else
      print "Error: request couldn't be issued"
    end if
    print "Initiating transfer '"; idkey; "' for url '"; url; "'"; " succeeded: "; ok
  else
    print "Error: invalid url: "; url
    m.top.numBadRequests++
  end if

  return true
end function

' processResponse():
'   Processes the HTTP response.
'   Sets the node's response field with the response info.
' parameters:
' 	msg: a roUrlEvent (https://sdkdocs.roku.com/display/sdkdoc/roUrlEvent)
function processResponse(msg as object)
  idKey = stri(msg.GetSourceIdentity()).trim()
  job = m.jobsById[idKey]

  if job = invalid then return "Error: event for unknown job " + idkey

  code = msg.GetResponseCode()
  context = job.context.context
  num = job.context.num

  result = {
    code: code,
    headers: msg.GetResponseHeaders(),
    content: msg.GetString(),
    context: context
  }
  if num <> invalid then result.context.jobnum = num
  ' could handle various error codes, retry, etc. here
  m.jobsById.delete(idKey)
  job.context.context.response = result
  if code = 200
    'm.Parser.response = (result.content, result.num)
    ' m.Parser.response = result
  else
    print "Error: status code was: " + code.toStr()
    m.top.numBadRequests++
    m.top.numRowsReceived++
  end if
end function
