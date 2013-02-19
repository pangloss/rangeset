require 'spec_helper'

describe RangeSet do
  subject { RangeSet.new 10..20, 30..40 }

  it 'should equal itself' do
    (subject == subject).should be_true
  end

  it 'should equal same' do
    (subject == RangeSet.new(10..20, 30..40)).should be_true
  end

  it 'should not equal different' do
    (subject == RangeSet.new(10..21, 30..40)).should be_false
  end

  it 'should equal equivalent range' do
    (RangeSet.new(10..20) == (10..20)).should be_true
  end

  context 'same' do
    let(:other) { RangeSet.new 10..20, 30..40 }
    it "should be all same" do
      subject.diff(other).should == [nil, subject, nil]
      subject.diff(other).should == [nil, other, nil]
    end
  end

  context 'subset' do
    let(:other) { RangeSet.new 30..40 }
    it do
      subject.diff(other).should == [10..20, 30..40, nil]
    end
  end

  context 'no overlap' do
    let(:other) { RangeSet.new 130..140 }
    it do
      subject.diff(other).should == [subject, nil, 130..140]
    end
  end

  context 'partial overlap' do
    let(:other) { RangeSet.new 35..140 }
    it do
      subject.diff(other).should == [RangeSet.new(10..20, 30..34), 35..40, 41..140]
    end
  end

  context 'engulfs' do
    let(:other) { RangeSet.new 11..19 }
    it do
      subject.diff(other).should == [RangeSet.new(10..10, 20..20, 30..40), other, nil]
    end
  end

  context 'engulfs2' do
    let(:other) { RangeSet.new 11..19, 35..36 }
    it do
      subject.diff(other).should == [RangeSet.new(10..10, 20..20, 30..34, 37..40), other, nil]
    end
  end

  context 'engulfed by' do
    let(:other) { RangeSet.new 1..50 }
    it do
      subject.diff(other).should == [nil, subject, RangeSet.new(1..9, 21..29, 41..50)]
    end
  end
end

