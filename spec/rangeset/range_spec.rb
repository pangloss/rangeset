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
  end
end
