class GroupPrices
  attr_reader :prices

  def initialize
    @prices = {
        '11' => 'E',
        '12' => 'R',
        '13' => 'W',
        '14' => 'X',
        '5' => '0',
        '6' => '1',
        '7' => '2',
        '8' => '3',
        '9' => '4',
        '10' => '5'
    }
  end
end