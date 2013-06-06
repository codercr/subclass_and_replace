require 'spec_helper'


describe SubclassAndReplace do
  before(:all) { @old_klass = MyTest::Base }

  let(:old_klass) { @old_klass }
  let(:new_klass) { @new_klass }

  it 'created subclass_and_replace method' do
    methods.include?(:subclass_and_replace)
    SubclassAndReplace.should_receive(:subclass_and_replace).with(MyTest::Base)

    subclass_and_replace MyTest::Base
  end

  it 'responds to #replaced_classes and return hash' do
    expect(SubclassAndReplace.replaced_classes).to be_instance_of(Hash)
  end

  context '#subclass_and_replace' do

    subject do
      @new_klass = subclass_and_replace MyTest::Base do
        def return_string
          super + new_string
        end

        def new_string
          'Bar'
        end
      end
    end

    it 'replaced the original MyTest::Base' do
      should_not be(old_klass)
      expect(MyTest::Base.superclass).to be(old_klass)
      should be(new_klass)
    end

    it 'added new_string method' do
      expect(MyTest::Base.new.new_string).to eq('Bar')
    end

    it 'replaced return_string method' do
      expect(old_klass.new.return_string).to eq('Foo')
      expect(MyTest::Base.new.return_string).to eq('FooBar')
    end

    it 'add replaced class to replaced_classes hash' do
      expect(SubclassAndReplace.replaced_classes).to eq( { 'MyTest::Base' => old_klass } )
    end

    it 'raises error and not replace a replaced class' do
      expect { subclass_and_replace MyTest::Base do

        def new_string
          'FAIL'
        end

      end }.to raise_error('\'MyTest::Base\' has already been replaced')

      expect(MyTest::Base.new.new_string).to eq('Bar')
      expect(MyTest::Base.new.return_string).to eq('FooBar')
    end

  end

  context '#revert' do

    before(:each) do
      @old_klass = Class.new do
        def return_string
          'Foo'
        end
      end

      MyTest.const_set(:RevertTest, @old_klass)

      @new_klass = subclass_and_replace MyTest::RevertTest do
        def return_string
          'Bar'
        end
      end
    end

    it 'places replaced class back' do
      expect(MyTest::RevertTest).to be(new_klass)
      expect(MyTest::RevertTest.new.return_string).to eq('Bar')

      expect { SubclassAndReplace.revert(MyTest::RevertTest) }.to change(SubclassAndReplace.replaced_classes, :size).by(-1)

      expect(MyTest::RevertTest).to be(old_klass)
      expect(MyTest::RevertTest.new.return_string).to eq('Foo')
    end

  end

end