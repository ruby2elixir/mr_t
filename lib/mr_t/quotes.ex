defmodule MrT.Quotes do
  def quote_of_day do
    bubble("Quote of the day: ", "   " <> (quotes |> Enum.random))
  end

  def bye do
    bubble("", "   I pity the fool who stops testing!" )
  end


  def bubble(title, text) do
    IO.puts "------------------------------------------------------------------------------------------------"
    IO.puts title
    IO.puts text
    IO.puts "------------------------------------------------------------------------------------------------"
  end

  def quotes do
    [
      # http://www.brainyquote.com/quotes/authors/m/mr_t.html
      # http://m.imdb.com/name/nm0001558/quotes
      # https://en.wikiquote.org/wiki/Mr._T
      "As a kid, I got three meals a day. Oatmeal, miss-a-meal and no meal.",
      "You might not have the things you want, but if you check carefully, you got all you need.",
      "I don't worry. I don't doubt. I'm daring. I'm a rebel.",
      "I'm a Christian - I really don't believe in UFOs.",
      "I don't like magic - but I have been known to make guys disappear.",
      "I believe in the Golden Rule - The Man with the Gold... Rules.",
      "When I was growing up, my family was so poor we couldn't afford to pay attention.",
      "As an actor, I'm more versatile than most people realize. I could play Hamlet, even though I look more like King Kong.",
      "It takes a smart guy to play dumb.",
      "I ain't no computer hacker!",
      "Mr. T has the greatest hair in the world. You can't deny it, it's been proven by science, fool!",
      "Well, maybe Mr. T hacked the game and created a Mohawk class! Maybe, Mr. T's pretty handy with computers! Had that occurred to you, Mr. \"Condescending\" Director?!",
      "People ask me what the \"T\" stands for in my name. If you're a man, the \"T\" stands for tough. If you're a woman or child, it stands for tender!",
    ]
  end
end
