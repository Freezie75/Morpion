require 'pry'

class Board_card
  attr_accessor :status

  @@instance = 0
  @@children = []

  def initialize(status = "")
    @status = status
    @@instance += 1
    @@children << self
  end

  def self.children
    @@children
  end
end

class Board < Board_card # Board hérite de Board_case
  
  def board_card_start
    up_left = Board_card.new
    up_center = Board_card.new
    up_right = Board_card.new
    middle_left = Board_card.new
    middle_center = Board_card.new
    middle_right = Board_card.new
    down_left = Board_card.new
    down_center = Board_card.new
    down_right = Board_card.new

    @board = [up_left, up_center,
      up_right,
      middle_left,
      middle_center,
      middle_right,
      down_left,
      down_center,
      down_right]
  end

  def sign_case(user_move)
    input = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    first_loop = false
    second_loop = false

    until first_loop && second_loop
      until input.include? user_move
        puts "Incorrect !"
        puts "Recommence..."
        user_move = gets.chomp.to_i - 1
      end

      first_loop = true
      
      until @board[user_move].status == ""
        puts "Incorrect !"
        puts "Recommence..."
        user_move = gets.chomp.to_i - 1
      end

      second_loop = true
    end

    user_move
  end

  def correct_input(user_move, user_symbol)
    @board[user_move].status = user_symbol
  end

  def print_table
    
    puts ""
    puts "                  " + @board[0].status + " | " + @board[1].status + " | " + @board[2].status
    puts "                 -------------"
    puts "                  " + @board[3].status + " | " + @board[4].status + " | " + @board[5].status
    puts "                 -------------"
    puts "                  " + @board[6].status + " | " + @board[7].status + " | " + @board[8].status
    puts ""
  end

  def winning(player)

    wins_scenario = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]

    wins_scenario.each do |scenario|
      sum = 0
      scenario.each do |tile|

        if @board[tile].status == player.symbol
          sum += 1

          if sum == 3
            player.winning = true
            return player.winning
            break            
          else
            player.winning = false
          end
        end
      end
    end
  end

  def rules_of_the_game
    @board_num = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    puts ""
    puts ""
    puts "Voici le plateau de jeu"

    puts ""
    puts "                              #{@board_num[0]} | #{@board_num[1]} | #{@board_num[2]}"
    puts "                              ---------"
    puts "                              #{@board_num[3]} | #{@board_num[4]} | #{@board_num[5]}"
    puts "                              ---------"
    puts "                              #{@board_num[6]} | #{@board_num[7]} | #{@board_num[8]}"
    puts ""
    puts "A chaque tour, chaque joueur choisi l'endroit où il veut mettre son symbole (X ou O)."
    puts "Le premier qui réussit à aligner 3 symboles sur la même ligne remporte la partie."
    puts "Amusez-vous bien :) !"
  end
end

class Player < Board
  attr_accessor :player_name, :winning, :symbol

  @@player_instance = 0
  @@instance_collector = []
  
  def initialize(winning = false, symbol)
    @@player_instance += 1
    @winning = winning
    @symbol = symbol
    @player_name = asking_names
    @@instance_collector << self
  end

  def asking_names
    puts "\n-------------------------------------------------------"
    puts "Quel est le nom du joueur #{@@player_instance} ?"
    player_name = gets.chomp

    return player_name
  end

  def self.offsprings
    @@instance_collector
  end
end

system "clear"
class Game < Player

  def initialize
    @board_instance = Board.new
    @player_1 = Player.new("X")
    @player_2 = Player.new("O")

    puts "Bienvenue #{@player_1.player_name} et #{@player_2.player_name}"

    @board_instance.board_card_start
    @board_instance.rules_of_the_game

    puts "Connaisser vous les règles du jeu ?"
    puts "Appuyer sur une touche pour continuer..."
    gets.chomp
    system "clear"
  end

  def round
    user_move = 0
    i = 0

    until Player.offsprings[0].winning || Player.offsprings[1].winning || i > 8
      Player.offsprings.each do |l|

        puts "\n------------------ Manche #{i + 1} --------------------"

        puts l.player_name + ", c'est à vous de jouer !"
        puts "Sur quel carré aller vous jouer ? [1-9]"

        user_move = gets.chomp.to_i - 1

        validation = @board_instance.sign_case(user_move)

        @board_instance.correct_input(validation, l.symbol)
        system "clear"
        @board_instance.print_table

        test_winning = @board_instance.winning(l)

        if test_winning == true
          puts "Félicitation " + l.player_name + ", vous avez gagné."
          puts "\n-------------------------------------------------------"

          finished_game = true
        end

        if i == 8 && @player_1.winning == @player_2.winning
          puts "\n-------------------------------------------------------"
          puts "Egalité, personne ne gagne"
          puts "\n-------------------------------------------------------"

          finished_game = true
        end

        if finished_game == true
          puts "Partie terminé"
          puts "\n-------------------------------------------------------"
        end

        i = i + 1

        break if finished_game == true
        end
      end
    end
  end

  def play_again

    puts "Voulez vous rejouer ?"
    puts "Appuyer sur Y pour confirmer ou sur une autre touche pour quitter le jeu"

    user_input = gets.chomp

    if user_input == "Y"
    else
      puts "A bientôt ;)"
    end

    user_input
  end

  def loop_game(instance, user_input)
    
    while user_input == "Y"
      Player.offsprings.each do |l|
        l.winning = false
      end

      Board_card.children.each do |tile|
        tile.status = ""
      end

      instance.round
    end
  end

@script = Game.new
@script.round
@script.loop_game(@script, @script.play_again)