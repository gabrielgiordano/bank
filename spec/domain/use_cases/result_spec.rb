# frozen_string_literal: true

require 'use_cases/result'

describe UseCases::Result do
  it 'is a success when status is :success' do
    expect(described_class.new(status: :success)).to be_success
  end

  it 'is a failure when status is not :success' do
    expect(described_class.new(status: :any)).to be_failure
  end

  it 'can be created with errors' do
    result = described_class.new(status: :failure, errors: :something)
    expect(result.errors).to eq :something
  end

  it 'can be created with data' do
    result = described_class.new(status: :success, data: :something)
    expect(result.data).to eq :something
  end

  describe '.success' do
    it 'creates a successful result' do
      expect(described_class.success).to be_success
    end
  end

  describe '.failure' do
    it 'creates a failure result' do
      expect(described_class.failure).to be_failure
    end
  end
end
