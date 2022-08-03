sub main()
  screen = createObject("roSGScreen")
  scene = screen.createScene("HomeScene")
  screen.Show()
  port = createObject("roMessagePort")
  screen.setMessagePort(m.port)
  while(true)
  end while
end sub
