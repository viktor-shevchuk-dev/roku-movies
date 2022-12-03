sub init()
  m.scoreContainer = m.top.findNode("scoreContainer")
  m.scoreValue = m.top.findNode("scoreValue")
  m.scorePercentage = m.top.findNode("scorePercentage")
  m.userScore = m.top.findNode("userScore")
  setFontSize(m.userScore, 24)
end sub

sub onPercentageChange(obj)
  percentage = obj.getData()
  m.scorePercentage.width = percentage
  m.scoreValue.text = percentage.toStr() + " %"

  m.scoreContainer.height = m.top.height
  m.scorePercentage.height = m.top.height
  m.scoreValue.height = m.top.height
end sub