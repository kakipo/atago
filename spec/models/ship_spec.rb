# coding: utf-8
require File.expand_path(File.join('../', 'spec_helper'), File.dirname(__FILE__))

describe Atago::Model::Ship do

  describe "#new" do
    context "when hash is empty" do
      it "should raise error" do
        expect { Atago::Model::Ship.new }.to raise_error(ArgumentError)
      end
    end
    context "when hash has values" do
      before do
        @hash = {
          "api_id"        => my_id,
          "api_ship_id"   => my_ship_id,
          "api_nowhp"     => my_nowhp,
          "api_maxhp"     => my_maxhp,
          "api_karyoku"   => [my_karyoku, 99],
          "api_raisou"    => [my_raisou, 99],
          "api_taiku"     => [my_taiku, 99],
          "api_soukou"    => [my_soukou, 99],
          "api_kaihi"     => [my_kaihi, 99],
          "api_sakuteki"  => [my_sakuteki, 99],
          "api_lucky"     => [my_lucky, 99],
          "api_cond"      => my_cond
        }
      end
      let(:my_id) { (rand * 100).to_i }
      let(:my_ship_id) { (rand * 100).to_i }
      let(:my_nowhp) { (rand * 100).to_i }
      let(:my_maxhp) { (rand * 100).to_i }
      let(:my_karyoku) { (rand * 100).to_i }
      let(:my_raisou) { (rand * 100).to_i }
      let(:my_taiku) { (rand * 100).to_i }
      let(:my_soukou) { (rand * 100).to_i }
      let(:my_kaihi) { (rand * 100).to_i }
      let(:my_sakuteki) { (rand * 100).to_i }
      let(:my_lucky) { (rand * 100).to_i }
      let(:my_cond) { (rand * 100).to_i }
      subject { Atago::Model::Ship.new(@hash) }
      it { should be_an_instance_of Atago::Model::Ship }
      its(:_id) { should eq my_id }
      its(:ship_id) { should eq my_ship_id }
      its(:nowhp) { should eq my_nowhp }
      its(:maxhp) { should eq my_maxhp }
      its(:karyoku) { should eq my_karyoku }
      its(:raisou) { should eq my_raisou }
      its(:taiku) { should eq my_taiku }
      its(:soukou) { should eq my_soukou }
      its(:kaihi) { should eq my_kaihi }
      its(:sakuteki) { should eq my_sakuteki }
      its(:lucky) { should eq my_lucky }
      its(:cond) { should eq my_cond }

    end
  end

end