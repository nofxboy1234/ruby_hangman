module Display
  def end_message
    if secret_word_guessed?
      puts 'You guessed the secret word!'
    else
      puts 'Game over. You ran out of incorrect guesses!'
    end
  end

  def display_info
    system 'clear'
    p secret_word
    p guess_word
    puts "incorrect guesses: #{incorrect_guesses}"
  end
end