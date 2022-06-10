sub main(obj)
  showChannelSGScreen()
end sub

sub showChannelSGScreen()
  screen = CreateObject("roSGScreen")
  scene = screen.createScene("home_scene")
  screen.Show()

  port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  ' this loop is necessary to keep the application open
  ' otherwise the channel will exit when it reaches the end of main()
  while(true)
    ' nothing happens in here, yet
    ' the HOME and BACK buttons on the remote will nuke the app
  end while
end sub