require './lib/model/field.rb'
require './lib/model/block.rb'

class Tetris
	attr_reader :cursor, :current_block, :field

	def initialize
		@events = {}
		@BlockFactory = BlockFactory.new()
		@cursor = [3, 0]
		@current_block = @BlockFactory.get_random()
		@field = Field.new()
		@fall_wait_init = 40
		@fall_wait = @fall_wait_init
		@game_controller = GameController.new()
	end

	def update
		if @game_controller.l_roll?
			unless @field.hit?(@current_block.left_next,
							  @cursor[0],
							  @cursor[1])
				@current_block.rotate_left()
			end
		end

		if @game_controller.r_roll?
			unless @field.hit?(@current_block.right_next,
							  @cursor[0],
							  @cursor[1])
				@current_block.rotate_right()
			end
		end

		x = @game_controller.x
		if x != 0
			unless @field.hit?(@current_block.current,
							  @cursor[0] + x,
							  @cursor[1])
				@cursor[0] += x
			end
		end

		y_accel = 0
		y = @game_controller.y
		if y > 0
			y_accel = 1
		end

		@fall_wait -= 1
		if @fall_wait < 0
			@fall_wait = @fall_wait_init
			y_accel = 1
		end

		if y_accel > 0
			if @field.hit?(@current_block.current,
							  @cursor[0],
							  @cursor[1] + y_accel)
				@field.merge(@current_block.current, @cursor[0], @cursor[1])
				remove_count = @field.remove_lined()
				if remove_count >= 1
				end
				if remove_count >= 4
					@events['tetrised'].each { |a| a.call() } 
				end
				@cursor = [1, 0]
				@current_block = @BlockFactory.get_random()
			else
				@cursor[1] += y_accel
			end
		end
	end

	def add_event_listener(name, action)
		@events[name] ||= Array.new()
		@events[name] << action
	end
end

class GameController
	def initialize
		Input.set_repeat(20, 2)
	end

	def x
		x = 0
		x -= 1 if Input.key_push?(K_LEFT)
		x += 1 if Input.key_push?(K_RIGHT)
		return x
	end

	def y
		y = 0
		y -= 1 if Input.key_push?(K_UP)
		y += 1 if Input.key_push?(K_DOWN)
		return y
	end

	def l_roll?
		Input.key_push?(K_Z)
	end

	def r_roll?
		Input.key_push?(K_X)
	end
end
