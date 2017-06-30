require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    %w(Questions Answers Comments Users).each do |obj|
      it "Array of #{obj}" do
        expect(ThinkingSphinx).to receive(:search).with('Request', classes: [obj.singularize.classify.constantize])
        Search.find('Request', obj.to_s)
      end
    end

    it "Any object" do
      expect(ThinkingSphinx).to receive(:search).with('Request')
      Search.find('Request', 'All')
    end

    it "Invalid condition" do
      result = Search.find('Request', 'Nonexistent')
      expect(result).to be_nil
    end
  end
end
