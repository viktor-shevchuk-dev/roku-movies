function generateImageUrl(filepath as dynamic, w as string, h as string) as string
  if filepath = invalid then return "" else return "https://image.tmdb.org/t/p/w" + w + "_and_h" + h + "_multi_faces" + filepath
end function