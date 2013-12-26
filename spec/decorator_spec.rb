# coding: utf-8
require File.expand_path(File.join('./', 'spec_helper'), File.dirname(__FILE__))

describe Atago::Decorator do

  describe "#new" do
    context "when filename is empty" do
      it "should raise error" do
        expect { Atago::Decorator.new }.to raise_error(ArgumentError)
      end
    end
    context "when filename has values" do
      subject { Atago::Decorator.new("data/formatter_test.csv") }
      it { should be_an_instance_of Atago::Decorator }
    end
  end

  describe "#header_str" do
    before { @dec = Atago::Decorator.new("data/formatter_test.csv") }
    subject { @dec.header_str }
    it { should eq "title0   title1 title2   title3" }
  end

end