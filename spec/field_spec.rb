require './lib/model/field.rb'
require './lib/model/block.rb'

describe Field do
	before do
		@obj = Field.new()
		@factory = BlockFactory.new()
	end

	it "should be 12*21" do
		@obj.layout.size.should == 21
		@obj.layout.each do |line|
			line.size.should == 12
		end
	end

	it "should be boolean" do
		@obj.layout.each do |line|
			line.each do |i|
				i.should_not be_nil
				i.should_not == ' '
#				pending('trueかfalse')
			end
		end
	end

	it "should be hit" do
		should be_hit(@factory.get_z().current, 0, 0)
		should be_hit(@factory.get_z().current, 9, 0)
		should be_hit(@factory.get_z().current, 1, 19)
		should_not be_hit(@factory.get_z().current, 1, 1)
		should_not be_hit(@factory.get_z().current, 2, 1)
		should_not be_hit(@factory.get_z().current, 3, 0)
		should_not be_hit(@factory.get_z().current, 4, 0)
		should_not be_hit(@factory.get_z().current, 5, 0)
		should_not be_hit(@factory.get_z().current, 6, 0)
		should_not be_hit(@factory.get_z().current, 7, 0)
		should_not be_hit(@factory.get_z().current, 8, 0)
		should_not be_hit(@factory.get_z().current, 1, 18)
	end

	it "should be mergeable" do
		block = @factory.get_z()
		@obj.should_not be_hit(block.current, 1, 1)
		@obj.merge(block.current, 1, 1)
		@obj.should be_hit(block.current, 1, 1)
	end

	it "should be line clearble" do
		@obj.merge(@factory.get_i().current, 1, 19)
		@obj.merge(@factory.get_i().current, 5, 19)
		@obj.merge(@factory.get_o().current, 9, 19)
		@obj.get_lined().should == [19]
	end

	it "should be removable" do
		@obj.merge(@factory.get_i().current, 1, 19)
		@obj.merge(@factory.get_i().current, 5, 19)
		@obj.merge(@factory.get_o().current, 9, 19)
		@obj.remove_lined()
		@obj.layout.should == Field.new().layout
	end
end

describe Layout do
	before do
		@factory = BlockFactory.new()
	end

	it "should be copiable" do
		l = [true, true, true]
		obj = Layout.new(l)
		obj.should have(3).items
	end

	it "should be convertable" do
		l = '# #'
		obj = Layout.new(l)
		obj.should have(1).items
		obj[0].should have(3).items
	end

	it "should be convertable from string-array" do
		l = ['# #',
			 '###']
		obj = Layout.new(l)
		obj.should have(2).items
		obj[0].should have(3).items
	end

	it "should be mergeable" do
		block = @factory.get_o()
		obj = Layout.new(
			['#  #',
			 '#  #',
			 '####'])
		obj.merge(block.current, 1, 0)
		obj.should == Layout.new(
			['####',
			 '####',
			 '####'])
	end
end

describe Block do
	before(:all) do
		@factory = BlockFactory.new
	end

	it "should be cloneable" do
		one = @factory.get_i
		two = @factory.get_i
		one.should_not be_equal two
		one.current.should have(1).items
		one.current[0].should have(4).items
	end

	it "should be rotatable" do
		block = @factory.get_i
		prev = Array.new(block.current)
		block.current.should == prev
		block.rotate_left()
		block.current.should_not == prev
		block.rotate_right()
		block.current.should == prev
	end

	it "should be equal next and rotated block" do
		block1 = @factory.get_s
		block2 = @factory.get_s
		block2.rotate_left()
		block1.left_next.should be_equal block2.current
		block2.rotate_left()
		block1.left_next.should_not be_equal block2.current
		block2.rotate_right()
		block2.rotate_right()
		block2.rotate_right()
		block1.right_next.should be_equal block2.current
	end
end

describe BlockFactory do
	before do
		@obj = BlockFactory.new
	end

	it "should be gettable" do
		i = @obj.get_i()
		i.should_not be_nil
		i2 = @obj.get_i()
		i2.should_not be_equal i
	end
end