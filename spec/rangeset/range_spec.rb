require 'spec_helper'

describe Range do
  subject { 10..20 }

  it 'should equal itself' do
    (subject == subject).should be_true
  end

  it 'should equal same' do
    (subject == (10..20)).should be_true
  end

  it 'should not equal different' do
    (subject == (10..21)).should be_false
  end

  it 'should equal equivalent RangeSet' do
    ((10..20) == RangeSet.new(10..20)).should be_true
  end

  describe '#diff' do
    subject { 30..40 }

    context 'diff with nill' do
      it do
        subject.diff(nil).should == [30..40, nil, nil]
      end
    end

    context 'partial overlap' do
      let(:other) { 35..140 }
      it do
        subject.diff(other).should == [30..34, 35..40, 41..140]
      end
    end

    context 'with a RangeSet' do
      let(:other) { RangeSet.new(1..10, 30..35) }
      it do
        subject.diff(other).should == [36..40, 30..35, 1..10]
      end
    end

    context 'encompassing a RangeSet' do
      subject { 0..8392 }
      let(:other) { r = RangeSet[2089..2787, 2789..7266, 8371..8376, 8381..8382, 8384..8386, 8391..8392] }
      it do
        subject.diff(other).should == [
          RangeSet[0..2088, 2788..2788, 7267..8370, 8377..8380, 8383..8383, 8387..8390],
          RangeSet[2089..2787, 2789..7266, 8371..8376, 8381..8382, 8384..8386, 8391..8392],
          nil]
      end
    end
  end
end
