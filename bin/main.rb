require 'dxruby'
require './lib/model/tetris.rb'

class View
	FIELD_LEFT = 250
	FIELD_TOP = 10
	CHARACTER_LEFT = 0
	CHARACTER_TOP = 120

	def initialize
		@block_image = Image.load('images/block.png')
		character = Image.load('images/reimu.jpg')
		voice = Sound.new('sounds/reimu.wav')

		tetris = Tetris.new()
		tetris.add_event_listener('tetrised', lambda { voice.play() })

		Window.bgcolor = [255, 255, 255]
		Window.loop do
			tetris.update()
			draw_layout(tetris.field.layout, 0, 0)
			draw_layout(tetris.current_block.current, tetris.cursor[0], tetris.cursor[1])
			Window.draw(CHARACTER_LEFT, CHARACTER_TOP, character)
		end
	end

	def draw_layout(layout, col, row)
		x = FIELD_LEFT + col * @block_image.width
		y = FIELD_TOP + row * @block_image.height
		layout.count.times { |r|
			layout[r].count.times { |c|
				if layout[r][c]
					Window.draw(
						x + (c * @block_image.width),
						y + (r * @block_image.height),
						@block_image)
				end
			}
		}
	end
end

View.new()
