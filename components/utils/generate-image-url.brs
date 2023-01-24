function generateImageUrl(filepath as dynamic, w as string, h as string) as string
  if filepath = invalid then return "" else return substitute("https://image.tmdb.org/t/p/w{0}_and_h{1}_multi_faces{2}", w, h, filepath)
end function