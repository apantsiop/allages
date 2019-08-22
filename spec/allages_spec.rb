require 'spec_helper'

RSpec.describe Allages do
  it "has a version number" do
    expect(Allages::VERSION).not_to be nil
  end

  it 'has a default config' do
    expect(Allages.config.input_dir).to eq 'changelogs'
  end
end
