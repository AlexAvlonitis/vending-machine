require 'spec_helper'
require 'coin_manager'

describe CoinManager do
  let(:subject) { described_class.new }

  let(:coin100) { double(:coin, value: 100) }
  let(:coin200) { double(:coin, value: 200) }
  let(:coin20) { double(:coin, value: 20) }
  let(:coin10) { double(:coin, value: 10) }
  let(:coin5) { double(:coin, value: 5) }
  let(:coin2) { double(:coin, value: 2) }
  let(:coins) { [coin100, coin100, coin200] }

  describe '#add_coins' do
    it 'adds them to the coins_bucket' do
      subject.add_coins(coins)
      expect(subject.coins_bucket)
        .to eq({ 100 => [coin100, coin100], 200 => [coin200] })
    end
  end

  describe '#deduct' do
    context 'when the the coins in the coins_bucket are enough' do
      let(:coins2) { coins + [coin20, coin20, coin10] }

      it 'removes and returns the coins' do
        subject.add_coins(coins2)
        expect(subject.total_amount).to eq(450)

        change = subject.deduct(50)
        expect(subject.total_amount).to eq(400)
        expect(change.sum(&:value)).to eq(50)
      end

      context 'but the coins cannot be divided to exact change' do
        let(:coins2) { coins + [coin20, coin10] }

        it 'raises not enough change error' do
          subject.add_coins(coins2)
          expect(subject.total_amount).to eq(430)

          expect { subject.deduct(50) }
            .to raise_error(CoinManager::NotEnoughChangeError)
        end
      end
    end

    context 'when the the coins in the coins_bucket are not enough' do
      let(:coins2) { [coin20, coin20, coin5, coin2, coin2] }

      it 'raises not enough change error' do
        subject.add_coins(coins2)
        expect(subject.total_amount).to eq(49)

        expect { subject.deduct(50) }
          .to raise_error(CoinManager::NotEnoughChangeError)
      end
    end
  end

  describe '#total_amount' do
    it 'returns the total amount of the stored coins' do
      subject.add_coins(coins)
      expect(subject.total_amount).to eq(400)
    end
  end
end
