#2d array class
# 24 may 2012

class Array2d
	@xsize=0
	@ysize=0
	def initialize x,y
		@xsize,@ysize=x,y
		@embed_array=Array.new x*y
	end
	def [](x,y)
		@embed_array[(y*@xsize)+x]
	end
	def []=(x,y,v)
		  @embed_array[(y*@xsize)+x]=v
	end
end
