#BSP dungeon class 
#27 may 2012
class BSPdungeon
        attr_accessor :map, :depth, :width, :height, :letsjoinlist
        def initialize width, height, max_depth
            @width, @height, @depth=width, height, max_depth
            @letsjoinlist=Array.new @depth do Array.new end
            @map=Array2d.new width, height
            @nodes=BSPdungeon_node.new self, nil, 0, 0, width-1, height-1
        end
end

class BSPdungeon_node
		attr_reader :depth, :x, :y, :x2, :y2, :splitdir, :map
	def initialize dungeon, parent,x,y,x2,y2
		@x,@y,@x2,@y2=x,y,x2,y2
        @dungeon=dungeon
		@parent,@left,@right=parent,nil,nil
		
		if @parent==nil #if parent is nil then this is the top level
			@depth=1
		else
			@depth=@parent.depth+1
		end
		
		if @depth==@dungeon.depth then
			shrink
		else
			split
			@dungeon.letsjoinlist[@depth].push self #building up the list of things to join later
		end
	
		if @parent==nil
			#we are at the top level and the split has been done and recursed all the way down
			#join and complete!
			(1..@dungeon.depth-1).reverse_each { |lev| @dungeon.letsjoinlist[lev].each { |xxx| xxx.join }}
		end
		
		
		
	end
	
	def map
		@dungeon.map
	end
	def width
		@x2-@x+1
	end
	def height
		@y2-@y+1
	end
	def split
		#minimum height or width of a panel split is 4 because that is w or h 2 plus surround
		#(to fit corridors in)
		amount=rand(40..60) #split from 40 to 60 %
		#cast the dice. pivot on .5 horiz or vert split
		choice=rand
		pivotx=amount.percentof width
		pivoty=amount.percentof height
		
		if choice<0.5 #we decide randomly to do Horiz split
			if not splithoriz pivotx
				if not splitvert pivoty
					error_out
				end	
			end
		else #we decide randomly to do vert split
			if not splitvert pivoty
				if not splithoriz pivotx
					error_out
				end
			end
		end
	end	
	def splithoriz p
		if p<4 or (@x2-(@x+p))<3 or (@depth==@dungeon.depth-1 and @y2-@y==(@dungeon.height-1))
			return false  #room would be too small on h split or is on last depth and never been split except horiz
		else
			@splitdir=:horiz 
			@left=BSPdungeon_node.new @dungeon, self,@x,@y,@x+p-1,@y2 #split into left and right rooms
			@right=BSPdungeon_node.new @dungeon, self,@x+p,@y,@x2,@y2
			
			true
		end
	end
	def splitvert p
		if p<4 or (@y2-(@y+p))<3 or (@depth==@dungeon.depth-1 and @x2-@x==(@dungeon.width-1))
			return false #room would be too small on v split or is on last depth and never been split except vert
		else
			@splitdir=:vert 
			@left=BSPdungeon_node.new @dungeon, self,@x,@y,@x2,@y+p-1 #split into up and down
			@right=BSPdungeon_node.new @dungeon, self,@x,@y+p,@x2,@y2 
			
			true
		end
	end
	def error_out
		print "Error"
		dump
		exit
	end
	def dump
		UI.normal
		#print "D #{@depth} W #{@x2-@x+1} H #{@y2-@y+1} x #{@x} y #{@y} x2 #{@x2} y2 #{@y2}\n"
		debugprint "@depth width height x y x2 y2"
		if @left then @left.dump end
		if @right then @right.dump end
	end
	def shrink
		#save registers! (x,y,x2,y2) the reason we still work on originals is because width and height fns use them
		sx=@x;sy=@y;sx2=@x2;sy2=@y2
		# first of all we shrink the rectangle by one block all the way round because that's its walls
		@x+=1 ; @y+=1 ; @x2-=1 ; @y2-=1
			
		shrink_w=if rand<0.5 then true else false end
		shrink_h=if rand<0.5 then true else false end
		if width<3 then shrink_w=false end# too narrow
		if height<3 then shrink_h=false end# too short
		
		if shrink_w
			width60=0.percentof width
			if width60<2 then width60=2 end
			if width-1==width60 then newwidth=width-1 else newwidth=rand(width60..width-1) end
			if not newwidth==nil #it's nil if width60==width
				delta=width-newwidth
				leftside=rand(0..delta)
				rightside=delta-leftside
				@x+=leftside
				@x2-=rightside
			end
		end
		
		if shrink_h
			height60=0.percentof height
			if height60<2 then height60=2 end
			if height-1==height60 then newheight=height-1 else newheight=rand(height60..height-1) end
			if not newheight==nil #it's nil if height60 == height
				delta=height-newheight
				topside=rand(0..delta)
				bottomside=delta-topside
				@y+=topside
				@y2-=bottomside
			end
		end
		
		#UI.filledrect @x,@y,@x2-@x+1,@y2-@y+1,UI::BLACK
		drawroom_in_map
		#vup back the original x,y,x2,y2
		@x=sx;@y=sy;@x2=sx2;@y2=sy2
		
	end
	def drawroom_in_map
		#UI.setbg UI::YELLOW
		#UI.setfg UI::BLACK
		(@y..@y2).each {|y|(@x..@x2).each {|x| @dungeon.map[x,y]=:floor; 
                                     #print ".".at x,y
    } }
	end
	
	def join
		#if @depth != @dungeon.depth-1 then return end #this will be deleted
		
		if @splitdir==:vert
			genesisx=rand(@x..@x2) #pick a random x point along the horizontal line
			path=shootray @left,genesisx,@left.y2,:up #shoot a ray up and see if we hit anything
			if path
				filldungeoncorridor path #####################
			else
				bentjoin @left,genesisx,@left.y2,:up  ########################
			end
			path=shootray @right,genesisx,@right.y,:down
			if path
				filldungeoncorridor path  ######################
			else
				bentjoin @right,genesisx,@right.y,:down ############################
			end
		else #@splitdir==:horiz			
			genesisy=rand(@y..@y2) #pick a random y point along the vertical line
			path=shootray @left,@left.x2,genesisy,:left #shoot a ray left and see if we hit anything
			if path
				filldungeoncorridor path ###############
			else
				bentjoin @left,@left.x2,genesisy,:left ###################
			end
			path=shootray @right,@right.x,genesisy,:right
			if path
				filldungeoncorridor path ##################
			else
				bentjoin @right,@right.x,genesisy,:right #########################
			end
		end
	end
	
	def bentjoin half,xx,yy,dir
		path=shootraystoside half,xx,yy,dir #same args as before, different fn name
		if path.empty? then
			error_out
		else
			filldungeoncorridor path
			#path.each {|f| filldungeoncorridor f}
		end		
	end
	
	def filldungeoncorridor p
		#takes an array of tuples and turns those map squares to corridor
		#UI.setfg @depth	
		#t=64
		p.each do |f|
			@dungeon.map[f[0],f[1]]=:corridor
			#t+=1;print t.chr.to_s.at f[0],f[1]
			#print ".".at f[0],f[1]
		end
	end
	
	@@DIRPAIRS={up: [0,-1], down: [0,1], left: [-1,0], right: [1,0] }
	
	def shootray half,startx,starty,direction
		#shoots a ray up, down, left or right checking ahead and to the left and right for corridors or rooms
		#returns false if it doesn't find one, or returns the path if it does
		dx,dy=@@DIRPAIRS[direction]
		tx,ty=startx,starty
		steps=[]
		loop do #loop for ever!
			if (dx==-1 and tx==half.x) or (dx==1 and tx==half.x2) or (dy==-1 and ty==half.y) or (dy==1 and ty==half.y2)
				return false #we got to the edge
			end
			steps << [tx,ty] # adds this square to steps.
			if (dx!=1 and tx-1>=half.x and @dungeon.map[tx-1,ty]!=nil) \
			or (dx!=-1 and tx+1<=half.x2 and @dungeon.map[tx+1,ty]!=nil) \
			or (dy!=1 and ty-1>=half.y and @dungeon.map[tx,ty-1]!=nil) \
			or (dy!=-1 and ty+1<=half.y2 and @dungeon.map[tx,ty+1]!=nil)
				return steps 
			end
			tx+=dx; ty+=dy
			
		end
	end
	
	def shootraystoside half,startx,starty,direction
		#follows the same path as "shootray" but instead of checking one square ahead and to sides
		#it shoots secondary rays out to each side. Also rather than returning with the first hit, we take all
		#hits and return them in an array of paths. if there's no paths the return array will be empty rather than return false
		dx,dy=@@DIRPAIRS[direction]
		tx,ty=startx,starty
		steps=[] ; firstel = []
		loop do #loop for ever!
			
			if dx!=0 then #we are going left or right so shoot rays up and down
				if (result=shootray half,tx,ty,:up) then steps << (firstel + result) end
				if (result=shootray half,tx,ty,:down) then steps << (firstel + result) end
			else #we are going up or down so shoot rays left and right
				if (result=shootray half,tx,ty,:left) then steps << (firstel + result) end
				if (result=shootray half,tx,ty,:right) then steps << (firstel + result) end
			end
			if (dx==-1 and tx==half.x) or (dx==1 and tx==half.x2) or (dy==-1 and ty==half.y) or (dy==1 and ty==half.y2)
				return steps.sample #we got to the edge
			end
			firstel << [tx,ty]
			tx+=dx; ty+=dy
			
		end
	end
	
end




