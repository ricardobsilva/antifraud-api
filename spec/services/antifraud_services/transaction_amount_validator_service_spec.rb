require 'rails_helper'  # Certifique-se de que o arquivo de suporte seja carregado

RSpec.describe AntifraudServices::TransactionAmountValidatorService do
  let(:subject) { described_class.new(amount).call }

  describe 'call' do
    context 'when successful' do
      let(:amount) { 1500 }

      it 'when the transaction amount is within the limit and before the cutoff time' do
        travel_to(Time.current.beginning_of_day + 21.hours) do
          expect(subject).to be_truthy
        end
      end
    end

    context 'when the transaction amount exceeds the limit or is after the cutoff time' do
      let(:amount) { 2_100 }

      it 'return false' do
        travel_to(Time.current.beginning_of_day + 22.hours) do
          expect(subject).to be_falsey
        end
      end
    end
  end
end
