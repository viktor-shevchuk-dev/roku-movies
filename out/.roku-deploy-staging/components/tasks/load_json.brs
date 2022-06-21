sub init()
  m.top.functionname = "request"
  m.top.response = ""
end sub

function request()
  url = m.top.url
  http = createObject("roUrlTransfer")
  http.RetainBodyOnError(true)
  port = createObject("roMessagePort")
  http.setPort(port)
  http.setCertificatesFile("common:/certs/ca-bundle.crt")
  http.InitClientCertificates()
  http.enablehostverification(false)
  http.enablepeerverification(false)
  http.setUrl(url)
  if http.AsyncGetToString() then
    msg = wait(10000, port)
    if (type(msg) = "roUrlEvent")
      if (msg.getresponsecode() > 0 and msg.getresponsecode() < 400)
        m.top.response = msg.getstring()
      else
        reason = msg.getfailurereason()
        responseCode = msg.getresponsecode()
        m.top.response = ""
        m.top.error = "The data failed to load. " + chr(10) + reason + chr(10) + "Code: " + responseCode.toStr() + chr(10) + "URL: " + url
      end if
      http.asynccancel()
    else if (msg = invalid)
      ? "The load failed."
      m.top.error = "The load failed."
      m.top.response = ""
      http.asynccancel()
    end if
  end if
end function