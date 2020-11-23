require_relative 'train.rb'

class PassengerTrain < Train

  attr_reader :type
  
  def initialize(number)
    @number = number
    @type = 'passenger'
    super
  end
end