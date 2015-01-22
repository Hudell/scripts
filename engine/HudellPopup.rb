$imported ||= {}
$imported[:HudellPopup] = 1.0

module HudellEngine
	@popups = []
	@myViewport = nil

	def self.getNewViewport
		return @myViewport if @myViewport

		@myViewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
		@myViewport.z = 100
		return @myViewport
	end

	def self.popups
		return @popups
	end

	def self.showPopup(message, stayOnScreen = false)
		@popups.push(HudellTextPopup.new(getNewViewport, message, stayOnScreen))
	end

	def self.showIconPopup(icon_index, message = '', stayOnScreen = false)
		@popups.push(HudellIconPopup.new(getNewViewport, icon_index, message, stayOnScreen))
	end	

	def self.killPopups
		@popups.each do |popup|
			if !popup
				next
			end
			popup.complete = true
			popup.update
			popup.dispose
		end

		@popups = []
	end

	def self.on_scene_call
		HudellEngine::killPopups unless SceneManager::scene_is?(Scene_Map)
	end
end

class HudellPopup < Sprite
	attr_accessor :complete
	attr_accessor :index

	def initialize(viewport, stayOnScreen)
		super(viewport)
		@complete = false
		@index = 0 - 1

		if stayOnScreen
			@timeout = false
			@x = 0
		else
			@timeout = 200
			@x = nil
		end

		@y = 0
		self.bitmap = Bitmap.new(Graphics.width, Graphics.height)
	end

	def dispose
		self.bitmap.dispose if self.bitmap
		super
	end

	def update
		super
		self.bitmap.clear
		return if @timeout == false
		@timeout -= 1

		if @timeout < 0
			@complete = true
		end
	end
end


class HudellIconPopup < HudellPopup
	def initialize(viewport, icon_index, message = '', stayOnScreen = false)
		super(viewport, stayOnScreen)
		@icon_index = icon_index
		@alpha = 0
		@decreasing = false
		@waiting = 0
		@message = message
		update
	end

	def update
		super

		icon_bitmap = Cache.system("Iconset")
		rect = Rect.new(@icon_index % 16 * 24, @icon_index / 16 * 24, 24, 24)

		if SceneManager::scene_is?(Scene_Map)
			if @message != ''
				width = @message.length * 8
				size = self.bitmap.text_size(@message)
				total_width = size.width + 20

				@x = (Graphics.width / 2) - (total_width / 2) if @x.nil?
				@y = 10
				
				if @index > 0
				 	@y += (@index * 30)
				end

				self.bitmap.blt(@x, @y, icon_bitmap, rect, @alpha)
				self.bitmap.font.outline = true
				self.bitmap.font.out_color.set(0, 0, 0, @alpha)
				self.bitmap.font.color.set(255, 255, 255, @alpha)
				self.bitmap.draw_text(@x + 20, @y, width, 25, @message, 1)
			else
				self.bitmap.blt(@x, @y, icon_bitmap, rect, @alpha)
			end
			
			if @timeout == false
				if @complete
					@alpha = 0
				else
					@alpha = 255
				end
			else
				if @waiting > 0
					@waiting -= 1
				elsif @decreasing
					@alpha -= 5
					if @alpha < 0
						@alpha = 0
						@complete = true
					end
				else
					@alpha += 5
					if @alpha >= 255
						@waiting = 20
						@decreasing = true
						@alpha = 255
					end
				end
			end
		else
			@complete = true
		end
	end	
end

class HudellTextPopup < HudellPopup
	def initialize(viewport, message, stayOnScreen = false)
		super(viewport, stayOnScreen)
		@message = message
		update
	end

	def update
		super
		size = self.bitmap.text_size(@message)
		width = @message.length * 8
		self.bitmap.draw_text(@x - 20, @y, width, 25, @message, 1)
		@y -= 2
	end
end	

class Spriteset_Map
	alias :hudellengine_update :update

	def get_next_index(start = 0)
		HudellEngine::popups.each do |popup|
			if !popup
				next
			end

			if popup.index == start
				return get_next_index(start + 1)
			end
		end

		return start
	end

	def update
		hudellengine_update

		remove = []

		if !HudellEngine::popups.nil?
			HudellEngine::popups.each do |popup|
				if !popup
					next
				end
				if popup.index < 0
					popup.index = get_next_index
				end
				popup.update

				if popup.complete
					remove << popup
				end
			end

			remove.each do |popup|
				if popup
					HudellEngine::popups.delete(popup).dispose
				end
			end
		end
	end
end	
