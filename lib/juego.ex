defmodule Juego do
  #defstruct [:deck, :player, :dealer, :round]


  def init() do
    IO.puts "¡Blackjack!"
    game = gameCreate()
    runGame(game)

  end

  def gameCreate() do
    IO.puts "Iniciando juego"
    deck = [
      {:A, :diamonds}, {:A, :hearts}, {:A, :spades}, {:A, :clubs},
      {2, :diamonds}, {2, :hearts}, {2, :spades}, {2, :clubs},
      {3, :diamonds}, {3, :hearts}, {3, :spades}, {3, :clubs},
      {4, :diamonds}, {4, :hearts}, {4, :spades}, {4, :clubs},
      {5, :diamonds}, {5, :hearts}, {5, :spades}, {5, :clubs},
      {6, :diamonds}, {6, :hearts}, {6, :spades}, {6, :clubs},
      {7, :diamonds}, {7, :hearts}, {7, :spades}, {7, :clubs},
      {8, :diamonds}, {8, :hearts}, {4, :hearts}, {8, :clubs},
      {9, :diamonds}, {9, :hearts}, {9, :spades}, {9, :clubs},
      {10, :diamonds}, {10, :hearts}, {10, :spades}, {10, :clubs},
      {:J, :diamonds}, {:J, :hearts}, {:J, :spades}, {:J, :clubs},
      {:Q, :diamonds}, {:Q, :hearts}, {:Q, :spades}, {:Q, :clubs},
      {:K, :diamonds}, {:K, :hearts}, {:K, :spades}, {:K, :clubs}
    ]
    player = %{cards: [], score: 0}
    dealer = %{cards: [], score: 0}
    round = 1
    %{deck: deck, player: player, dealer: dealer, round: round}
  end

  @spec drawCard(list) :: {any, list}
  def drawCard(deck) do
    card = Enum.random(deck)
    newdeck = deck -- [card]
    {card, newdeck}
  end

  def newScore(list) do
    score = Enum.reduce(list, 0, fn card, acc ->
      acc + score_card(card)
    end)
    x = Enum.count(list, fn {value, _} -> value == :A end)
    recal(score, x)
  end


  def recal(score, x) when score > 21 and x > 0 do
    recal(score - 10, x - 1)
  end

  def recal(score, _x) do
    score
  end

  def newRound(game) do
    {card, deck} = drawCard(game.deck)
    cards1 = [card] ++ game.player.cards
    player1 = %{cards: cards1, score: newScore(cards1)}
    {card, newdeck} = drawCard(deck)
    cards2 = [card] ++ game.dealer.cards
    dealer1 = %{cards: cards2, score: newScore(cards2)}
    round = game.round + 1
    %{deck: newdeck, player: player1, dealer: dealer1, round: round}
  end

  def printPoint(game) do
    IO.puts("Tus cartas son : ")
    IO.inspect(game.player.cards)
    IO.puts("Tienes #{game.player.score} puntos \n")
    IO.puts("La casa tiene : ")
    IO.inspect(game.dealer.cards)
    IO.puts("La casa tiene #{game.dealer.score} puntos")
  end

  def runGame(game) do
    IO.puts("¿Quieres una carta?")
    x = IO.gets("Y / N :" ) |> String.trim() |> String.upcase()
    if (x === "Y") do
      game = newRound(game)
      printPoint(game)
      winner(game)
    else
      gameEnd(game)
    end
  end

  def winner(game) when game.player.score > 21 do
    IO.puts("\n\n Perdiste tu puntaje es #{game.player.score}")
  end

  def winner(game) when game.dealer.score > 21 do
    IO.puts("\n\n Ganaste tu puntaje es #{game.player.score}")
    IO.puts("\n\n La casa tiene #{game.dealer.score}")
  end

  def winner(game) when game.player.score == 21 do
    IO.puts("\n\n Ganaste tu puntaje es #{game.player.score}")
    IO.puts("\n\n La casa tiene #{game.dealer.score}")
  end

  def winner(game) when game.dealer.score == 21 do
    IO.puts("\n\n Ganaste tu puntaje es #{game.player.score}")
    IO.puts("\n\n La casa tiene #{game.dealer.score}")
  end

  def winner(game) do
    runGame(game)
  end

  def gameEnd(game) when 21 - game.player.score > 21 - game.dealer.score do
    IO.puts("\n\n Perdiste tu puntaje es #{game.player.score}")
    IO.puts("\n\n La casa tiene #{game.dealer.score}")
  end

  def gameEnd(game) when 21 - game.player.score < 21 - game.dealer.score do
    IO.puts("\n\n Ganaste tu puntaje es #{game.player.score}")
    IO.puts("\n\n La casa tiene #{game.dealer.score}")
  end

  def gameEnd(game) when game.player.score == 0 do
    IO.puts("\n\n Gracias por particiar")
  end

  def score_card({:K, _}), do: 10
  def score_card({:Q, _}), do: 10
  def score_card({:J, _}), do: 10
  def score_card({:A, _}), do: 11
  def score_card({n, _}) when n in 2..10, do: n

end
