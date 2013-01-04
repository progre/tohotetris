class Field
	attr_reader :layout

	def initialize
		layout_str = [
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'#          #',
			'############'
		]
		@layout = Layout.new(layout_str)
	end

	def hit?(layout, col, row)
		layout.count.times do |r|
			layout[r].count.times do |c|
				if layout[r][c] && @layout[r + row][c + col]
					return true
				end
			end
		end
		return false
	end

	def merge(block_layout, col, row)
		@layout.merge(block_layout, col, row)
	end

	def get_lined
		result = []
		@layout.count.times do |r|
			break if r == 20
			not_lined = false
			@layout[r].each do |one|
				if one == false
					not_lined = true
					break
				end
			end
			if not_lined
				next
			end
			result << r
		end
		return result
	end

	def remove_lined
		lined = get_lined()
		lined.each do |i|
			layout.delete_at(i)
			layout.unshift('#          #')
		end
		return lined.count
	end
end
