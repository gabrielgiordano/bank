# frozen_string_literal: true

require_relative '../../config/initializers/context'

class DummyRepository; end

describe Context do
  it 'is possible to register a repository' do
    Context.register_repository(key: :dummy, repository: DummyRepository)

    result = Context.repository(key: :dummy)

    expect(result).to eq DummyRepository
  end
end
