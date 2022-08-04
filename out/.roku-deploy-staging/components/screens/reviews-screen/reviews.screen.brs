sub onVisibleChange()
  if m.top.visible = true then
    m.reviewslist.setFocus(true)
  end if
end sub

sub init()
  m.heading = m.top.FindNode("heading")
  m.reviewslist = m.top.findNode("reviewsList")
  m.top.observeField("visible", "onVisibleChange")
end sub

sub onReviewsChanged(obj)
  reviews = obj.getData()
  m.heading.text = reviews.title
  adjustHeading(m.heading)

  m.reviewslist.content = CreateObject("roSGNode", "ReviewsListContent")
  m.reviewslist.content.reviews = reviews.reviews
  m.reviewslist.setFocus(true)
end sub
