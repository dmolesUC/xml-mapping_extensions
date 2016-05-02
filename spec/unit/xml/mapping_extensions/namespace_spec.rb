require 'spec_helper'

module XML
  module MappingExtensions
    describe Namespace do
      describe '#set_default_namespace' do
        it 'sets the default namespace'
        it 'sets the schema location'
      end

      describe '#set_prefix' do
        it 'sets the prefix'
        it 'clears the no-prefix namespace, if previously present'
        it 'leaves an unrelated no-prefix namespace intact'
      end
    end
  end
end
