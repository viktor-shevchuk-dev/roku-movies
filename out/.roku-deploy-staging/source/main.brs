sub main()
  screen = createObject("roSGScreen")
  screen.createScene("MainScene")
  screen.Show()
  createObject("roMessagePort")
  screen.setMessagePort(m.port)
  while(true)
  end while
end sub
