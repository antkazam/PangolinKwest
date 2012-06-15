#isometric.rb
#added 14 june 2012
#using gosu to draw the map. let's see how it goes!

#require 'rubygems'
require 'gosu'
#include Gosu


class Map 
	def initialize window,dungeon
		@window=window
		@dungeon=dungeon
		@tileset = Gosu::Image.load_tiles(window, "blocks.png", 32, 32, true)
		#@tileset[<the tile number>].draw(x * 50 - 5, y * 50 - 5, 0)
     end
     def draw
		(@dungeon.y..@dungeon.y2).each do |y|
			(@dungeon.x..@dungeon.x2).each do |x|
				case @dungeon.map[x,y]
					when :floor
						t=0
					when :corridor
						t=0
					else
						t=3
				end
				if t!=0 then
					@tileset[21].draw @window.xsize/2+(-y*16)+(x*16),(x*8)+(y*8),y
				else
					@tileset[0].draw @window.xsize/2+(-y*16)+(x*16),16+(x*8)+(y*8),y
				end
			end
		end
		
     end
end

class Graphicalwindow < Gosu::Window
	attr_reader :xsize,:ysize
	def initialize dungeon
		@xsize=1600 ; @ysize=768
		super @xsize,@ysize, false
		self.caption = "Pangolin Kwest"
		@map=Map.new self, dungeon
	end
  
	def update
	end
  
	def draw
		@map.draw
	end
  
end


