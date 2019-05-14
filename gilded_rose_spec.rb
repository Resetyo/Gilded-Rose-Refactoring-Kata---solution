require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  let(:usual_sell_in_0_qlty_0) { Item.new name="Foo", sell_in=0, quality=0 }
  let(:usual_sell_in_3_qlty_3) { Item.new name="Foo", sell_in=3, quality=3 }
  let(:usual_sell_in_0_qlty_50) { Item.new name="Foo", sell_in=0, quality=50 }
  let(:sulf_sell_in_10) do
    Item.new name="Sulfuras, Hand of Ragnaros", sell_in=10, quality=80
  end
  let(:brie_sell_in_2_qlty_0) { Item.new name="Aged Brie", sell_in=2, quality=0 }
  let(:brie_sell_in_2_qlty_50) { Item.new name="Aged Brie", sell_in=2, quality=50 }
  let(:brie_sell_in_0_qlty_0) { Item.new name="Aged Brie", sell_in=0, quality=0 }
  let(:backstg_sell_in_5_qlty_10) do
    Item.new name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=10
  end
  let(:backstg_sell_in_10_qlty_10) do
    Item.new name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=10
  end
  let(:backstg_sell_in_0_qlty_10) do
    Item.new name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=10
  end
  let(:backstg_sell_in_15_qlty_10) do
    Item.new name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=10
  end
  let(:conjured_sell_in_15_qlty_10) do
    Item.new name="Conjured Item", sell_in=15, quality=10
  end

  describe '#update_quality' do
    context 'on standard goods' do
      it 'does not change the name' do
        GildedRose.new([usual_sell_in_3_qlty_3]).update_quality
        expect(usual_sell_in_3_qlty_3.name).to eq "Foo"
      end

      it 'decreases the sell_in' do
        GildedRose.new([usual_sell_in_3_qlty_3]).update_quality
        expect(usual_sell_in_3_qlty_3.sell_in).to eq 2
      end

      it 'decreases the quality' do
        GildedRose.new([usual_sell_in_3_qlty_3]).update_quality
        expect(usual_sell_in_3_qlty_3.quality).to eq 2
      end

      it "quality can't be negative"  do
        GildedRose.new([usual_sell_in_0_qlty_0]).update_quality
        expect(usual_sell_in_0_qlty_0.quality).to eq 0
      end

      it "degrades twice after sell by date has passed"  do
        GildedRose.new([usual_sell_in_0_qlty_50]).update_quality
        expect(usual_sell_in_0_qlty_50.quality).to eq 48
      end
    end

    context 'on Sulfuras' do
      it 'quality and sell_in are never alters' do
        GildedRose.new([sulf_sell_in_10]).update_quality
        expect(sulf_sell_in_10.sell_in).to eq 10
        expect(sulf_sell_in_10.quality).to eq 80
      end
    end

    context 'on Aged Brie' do
      it 'increases the quality' do
        GildedRose.new([brie_sell_in_2_qlty_0]).update_quality
        expect(brie_sell_in_2_qlty_0.quality).to eq 1
      end

      it 'increases the quality twice after sell by date has passed' do
        GildedRose.new([brie_sell_in_0_qlty_0]).update_quality
        expect(brie_sell_in_0_qlty_0.quality).to eq 2
      end

      it "quality can't be more than 50"  do
        GildedRose.new([brie_sell_in_2_qlty_50]).update_quality
        expect(brie_sell_in_2_qlty_50.quality).to eq 50
      end
    end

    context 'on Backstage passes' do
      it 'increases by 3 when there are 5 days or less' do
        GildedRose.new([backstg_sell_in_5_qlty_10]).update_quality
        expect(backstg_sell_in_5_qlty_10.quality).to eq 13
      end

      it 'increases by 2 when there are 10 days or less' do
        GildedRose.new([backstg_sell_in_5_qlty_10]).update_quality
        expect(backstg_sell_in_5_qlty_10.quality).to eq 13
      end

      it 'increases by 1 in other cases' do
        GildedRose.new([backstg_sell_in_15_qlty_10]).update_quality
        expect(backstg_sell_in_15_qlty_10.quality).to eq 11
      end

      it 'quality drops to 0 after the concert' do
        GildedRose.new([backstg_sell_in_0_qlty_10]).update_quality
        expect(backstg_sell_in_0_qlty_10.quality).to eq 0
      end
    end

    context 'Conjured' do
      it 'degrade in quality twice as fast as normal items' do
        GildedRose.new([conjured_sell_in_15_qlty_10]).update_quality
        expect(conjured_sell_in_15_qlty_10.quality).to eq 8
      end
    end
  end
end
