require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'encryptable', [:title, :content]
end