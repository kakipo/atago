# coding: utf-8
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe Atago::Model::Deck do

  describe "#new" do
    context "when hash is empty" do
      it "should raise error" do
        expect { Atago::Model::Ship.new }.to raise_error(ArgumentError)
      end
    end
    context "when hash has values" do
      before do
        @hash = {
          "api_id"    => my_id,
          "api_name"  => my_name
        }
      end
      let(:my_id) { 999 }
      let(:my_name) { "my dock" }
      subject { Atago::Model::Deck.new(@hash) }
      it { should be_an_instance_of Atago::Model::Deck }
      its(:_id) { should eq my_id }
      its(:name) { should eq my_name }
    end
  end

end