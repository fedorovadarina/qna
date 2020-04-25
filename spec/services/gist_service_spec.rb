require 'rails_helper'

RSpec.describe GistService do
  let!(:question) { create(:question) }
  let(:gist_link) { question.links.create!(name: 'Gist link', url: 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c') }
  let(:gist_invalid_link) { question.links.create!(name: 'Invalid gist link', url: 'https://gist.github.com/fedorovadarina/0') }

  describe 'show gist contents' do
    it 'render gist' do
      expect(GistService.new(gist_link).content).to eq [['sample.rb', "puts 'Hello, world!\""]]
    end

    it 'return "not found" for invalid gist' do
      expect(GistService.new(gist_invalid_link).content).to eq [[gist_invalid_link.name, 'Gist not found']]
    end
  end
end