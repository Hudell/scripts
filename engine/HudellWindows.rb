$imported ||= {}
$imported[:HudellWindows] = 1.0

class Window_HudellSelectable < Window_Selectable
	def initialize(x, y, width, height)
		super
		@data = []
	end

	def col_max
		2
	end

	def select_last
		select(0)
	end

	def item_max
		@data ? @data.size : 1
	end

	def item
		@data && index >= 0 ? @data[index] : nil
	end

	def current_item_enabled?
		enable?(item)
	end

	def include?(item)
		true
	end

	def enable?(item)
		true
	end

	def refresh
		make_item_list
		create_contents
		draw_all_items
	end
end

class Window_HudellTitle < Window_Base
	def initialize(y, line_number = 1)
		super(0, y, Graphics.width, fitting_height(line_number))
	end
	
	def set_text(text)
		if text != @text
			@text = text
			refresh
		end
	end
	
	def clear
		set_text("")
	end
	
	def refresh
		contents.clear
		draw_text_ex(4, 0, @text)
	end  
end

class Window_Base < Window
	def draw_text_ex2(x, y, text)
		text = convert_escape_characters(text)
		pos = {:x => x, :y => y, :new_x => x, :height => calc_line_height(text)}
		process_character(text.slice!(0, 1), text, pos) until text.empty?
	end	
end
