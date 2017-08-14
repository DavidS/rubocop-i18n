# frozen_string_literal: true
require 'spec_helper'

describe RuboCop::Cop::I18n::GetText::DecorateFunctionMessage do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }
  before(:each) {
    investigate(cop, source)
  }

  it_behaves_like 'accepts', 'fail _("a string")'
  it_behaves_like 'accepts', 'raise _("a string")'
  it_behaves_like 'accepts', "fail _('a string')"
  it_behaves_like 'accepts', "raise _('a string')"

  context 'undecorated fail double-quoted string' do
    let(:source) { 'fail "a string"' }

    it 'has the correct message' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should have a decorator around the message/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'undecorated fail single-quoted string' do
    let(:source) { "fail 'a string'" }

    it 'has the correct message' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should have a decorator around the message/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'undecorated raise double-quoted string' do
    let(:source) { 'raise "a string"' }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should have a decorator around the message/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'undecorated raise single-quoted string' do
    let(:source) { "raise 'a string'" }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should have a decorator around the message/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'multiline fail string', broken: true do
    let(:source) { <<-RUBY
fail <<-STR
  this
  is
  a
  string
STR
RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should not use a multi-line string/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'multiline raise string', broken: true do
    let(:source) { <<-RUBY
raise <<-STR
  this
  is
  a
  string
STR
RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should not use a multi-line string/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'concatenated fail string' do
    let(:source) { <<-RUBY
fail "this" + "string" + "is" + "concatenated"
    RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should not use a concatenated string/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'concatenated raise string' do
    let(:source) { <<-RUBY
raise "this" + "string" + "is" + "concatenated"
    RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/should not use a concatenated string/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'interpolated fail string' do
    let(:source) { <<-RUBY
var = "foo"
fail "this string has a \#{var}"
    RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/interpolation is a sin/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

  context 'interpolated raise string' do
    let(:source) { <<-RUBY
var = "foo"
raise "this string has a \#{var}"
    RUBY
    }

    it 'rejects' do
      expect(cop.offenses[0]).not_to be_nil
      expect(cop.offenses[0].message).to match(/interpolation is a sin/)
    end

    it 'has the correct offenses' do
      expect(cop.offenses.size).to eq(1)
    end
  end

end