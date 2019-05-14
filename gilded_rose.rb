class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      factor = 1

      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        next
      when 'Aged Brie'
        factor = -1
      when 'Backstage passes to a TAFKAL80ETC concert'
        factor = -1
        if item.sell_in <= 0
          multiplicator = 0
          item.quality = 0
        elsif item.sell_in <= 5
          multiplicator = 3
        elsif item.sell_in <= 10
          multiplicator = 2
        else
          multiplicator = 1
        end
      when 'Conjured Item'
        multiplicator = 2
      end

      # standard goods
      multiplicator ||= item.sell_in > 0 ? 1 : 2
      item.quality -= (multiplicator * factor)
      item.quality = 0 if item.quality < 0
      item.quality = 50 if item.quality > 50

      item.sell_in -= 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
