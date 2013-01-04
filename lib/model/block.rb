#encoding: utf-8

class BlockFactory
	def initialize
		@Blocks = Array.new(7)
 		@Blocks[0] = Block.new([
 			['####'],
			['  # ',
			 '  # ',
			 '  # ',
			 '  # ']])
 		@Blocks[1] = Block.new([
			['##',
			 '##']])
 		@Blocks[2] = Block.new([
 			['## ',
 			 ' ##'],
			[' #',
			 '##',
			 '# ']])
 		@Blocks[3] = Block.new([
 			[' ##',
 			 '##'],
			['# ',
			 '##',
			 ' #']])
 		@Blocks[4] = Block.new([
 			['#  ',
 			 '###'],
 			[' #',
 			 ' #',
 			 '##'],
 			['###',
 			 '  #'],
			['##',
			 '# ',
			 '# ']])
 		@Blocks[5] = Block.new([
 			['  #',
 			 '###'],
 			['##',
 			 ' #',
 			 ' #'],
 			['###',
 			 '#  '],
			['# ',
			 '# ',
			 '##']])
 		@Blocks[6] = Block.new([
 			[' # ',
 			 '###'],
 			[' #',
 			 '##',
 			 ' #'],
 			['###',
 			 ' # '],
			['# ',
			 '##',
			 '# ']])
	end

	def get_random
		@Blocks[rand(7)].clone()
	end

	def get_i
		@Blocks[0].clone()
	end

	def get_o
		@Blocks[1].clone()
	end

	def get_z
		@Blocks[2].clone()
	end

	def get_s
		@Blocks[3].clone()
	end

	def get_j
		@Blocks[4].clone()
	end

	def get_l
		@Blocks[5].clone()
	end

	def get_t
		@Blocks[6].clone()
	end
end

class Block
	def initialize(layouts)
		if layouts.is_a?(Array) && layouts.size > 0 && layouts[0].is_a?(Layout)
			@layouts = layouts
		else
			@layouts = layouts.map { |i| Layout.new(i) }
		end
		@rotate_index = 0
	end

	def clone
		Block.new(@layouts)
	end

	def current
		@layouts[@rotate_index]
	end

	def rotate_left
		@rotate_index += 1
		if @rotate_index >= @layouts.size
			@rotate_index = 0
		end
	end

	def rotate_right
		@rotate_index -= 1
		if @rotate_index < 0
			@rotate_index = @layouts.size - 1
		end
	end

	def left_next
		rotate_left()
		next_ = current()
		rotate_right()
		return next_
	end

	def right_next
		rotate_right()
		next_ = current()
		rotate_left()
		return next_
	end
end

class Layout < Array # 2重配列
	def initialize(layout = nil)
		case layout
		when nil
			super(0)
		when String
			super(0)
			from_string(layout)
		when Array
#			if layout.all? {|i| i == true || i == false} # どちらかがって無かったっけか？
			if layout.all? {|i| [true, false].include?(i) } # >>632
				super(layout)
			elsif layout.all? {|i| i.is_a?(String) }
				super(0)
				from_string_array(layout)
			else
				super(0)
			end
		end
	end

	def from_string(layout_str)
		layout_str.split("\n").each do |line|
			push(line.chars.to_a) # >>618
		end
		each do |line|
			line.map! { |c| char_to_bool(c) }
		end
	end

	def from_string_array(layout_str_array)
		layout_str_array.each do |line|
			push(line.chars.to_a) # >>618
		end
		each do |line|
			line.map! { |c| char_to_bool(c) }
		end
	end

	def unshift(*obj)
		obj.map { |line| line.chars.to_a.map { |c| char_to_bool(c) } }
			.each { |line| super(line) }
	end

	def string_to_bools(c)
		c != ' '
	end

	def char_to_bool(c)
		c != ' '
	end

	def merge(layout, col, row)
		layout.count.times do |r|
			layout[r].count.times do |c|
				value = layout[r][c]
				self[r + row][c + col] = value if value != false
			end
		end
	end
end
