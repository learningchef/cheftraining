require_relative 'spec_helper'

describe 'docker' do
  it 'should have a docker group' do
    expect(group 'docker').to exist
  end
  
  it 'should have a vagrant user belonging to docker group' do
    expect(user 'vagrant').to belong_to_group 'docker'
  end
end
