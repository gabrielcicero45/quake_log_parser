class Player
  attr_accessor :name, :points

  def initialize(name)
      @name = name
      @points = 0
  end

  def inspect
    {name: name, points: points}
  end

  def to_s
    "#{name}: #{points}"
  end

  def add_point
    @points +=1
  end

  def remove_point
    @points -=1 if (@points > 0)
  end

end
