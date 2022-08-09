
sub personCLickHandler(obj)
  selectedIndex = obj.getData()
  selectedPerson = m.peopleScreen.findNode("peopleGrid").content.getChild(selectedIndex)
  m.personScreen.content = selectedPerson
  showNewScreenWithSavingCurrent(m.personScreen.id)
end sub