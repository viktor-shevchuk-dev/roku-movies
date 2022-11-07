sub main()
  screen = createObject("roSGScreen")
  screen.createScene("HomeScene")
  screen.Show()
  createObject("roMessagePort")
  screen.setMessagePort(m.port)
  while(true)
  end while
end sub
