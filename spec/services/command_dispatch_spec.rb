# frozen_string_literal: true
require 'rails_helper'

describe CommandDispatch do
  subject(:service) { described_class.new(platform, command) }

  let(:platform) { 'slack' }

  context 'with an unknown command' do
    let(:command_obj) { instance_spy(Commands::Unknown) }
    let(:command) { 'Not a known command' }

    before do
      allow(Commands::Unknown).to receive(:new).and_return(command_obj)
      allow(command_obj).to receive(:call)
      service.call
    end

    it 'instantiates Commands::Unknown' do
      expect(Commands::Unknown).to have_received(:new).with(no_args)
    end

    it 'calls the command object' do
      expect(command_obj).to have_received(:call)
    end
  end

  context 'with parsable date' do
    shared_examples 'Commands::Date invocation' do
      let(:command_obj) { instance_spy(Commands::Date) }

      it 'instantiates Commands::Date with expected args' do
        expect(Commands::Date).to(
          have_received(:new).with(date: Date.parse(command), option: command.split(' ').last)
        )
      end

      it 'calls the command object' do
        expect(command_obj).to have_received(:call)
      end
    end

    before do
      allow(Commands::Date).to receive(:new).and_return(command_obj)
      allow(command_obj).to receive(:call)
      service.call
    end

    context 'with database format' do
      let(:command) { '1995-10-31' }

      include_examples 'Commands::Date invocation'
    end

    context 'with long date format' do
      let(:command) { 'October 31, 1995' }

      include_examples 'Commands::Date invocation'
    end

    context 'with `more` option' do
      let(:command) { 'October 31, 1995 more' }

      include_examples 'Commands::Date invocation'
    end
  end
end
