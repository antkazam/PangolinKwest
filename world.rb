# graspee's program that does something. maybe
# started 2 may 2012

#require 'io/console'

load 'array2d.rb'
load 'BSPdungeon.rb'
#load 'ui.rb'
#load  "isometric.rb"
load "brick.rb"

#adding a method to string for sake of syntax. adds method overhead though. nasty

class String
    def at x,y
	"\e[#{y+1};#{x+1}H" + self
    end
end

def debugprint s
	s.split.each do |f| print f + ": "  + (eval f).to_s + " " end
	print "\n"
end
class Fixnum
	def percentof x
		((x/100.0)*self).round
	end
end

def ruby_balloon xpos,ypos
       #clips balloon vertically but not horizontally
       limit=STDOUT.winsize[0]
       print " .--. ".at xpos,ypos if ypos<limit
       print ":ruby;".at xpos,ypos+1 if ypos<limit-1
       print " '..' ".at xpos,ypos+2 if ypos<limit-2
       print "  vv  ".at xpos,ypos+3 if ypos<limit-3
       print "  MM  ".at xpos,ypos+4 if ypos<limit-4
       print "      ".at xpos,ypos+5 if ypos<limit-5
       print "".at 0,0
end

def ruby_balloon!
    25.downto 12 do |i| 
	ruby_balloon 12,i
	STDIN.flush
	STDIN.getch
	end
end



class World
	attr_accessor :screen_height, :screen_width
	def initialize
		@width=200
		@height=200
		@goffs=Array2d.new 200,200
		
		@screen_width=90
		@screen_height=45
		@x=0
		@y=0
		@playerx=@screen_width/2
		@playery=@screen_height/2
		#set console size with ANSI code
		print "\e[8;#{@screen_height};#{@screen_width}t"
		#cls 
		print "\e[2J"
		#enable extended characters
		print "\e(U"
	    end
	    
	def generate_outside
		(0..199).each do |y|
			(0..199).each do |x|
				@goffs[x,y]=rand(1..10)
			end
		end
	end

	def movedown
		@y+=1
	end

	def draw
		print "\e[0;0H" #put cursor at origin
		(@y..@y+@screen_height-1).each do
			|y|
			(@x..@x+@screen_width-1).each do
				|x|
				case @goffs[x,y]
					when 1
						print "\e[30;42mT"
					when 2,3,4
						print "\e[31;42m:"
					else
						print "\e[30;43m."

				end
			end
		end
	end
	

	
end



#test this thing if i can!




#x=World.new
#x.generate_outside
#x.draw
#(1..10).each do
    
#    x.movedown
#    x.draw
#end

#UI.frame 0,0,12,9,:double

#UI.hpbar "HP 55/100",1,1,10,UI::RED,55,100 #red
#UI.hpbar "MP 79/100",1,2,10,UI::BLUE,79,100 #blue
#UI.hpbar "AGI",1,3,10,UI::GREEN,21,100 #green
#UI.hpbar "VIT",1,4,10,UI::WHITE,93,100 #white
#UI.hpbar "ATT",1,5,10,UI::CYAN,97,100 #cyan
#UI.hpbar "DEF",1,6,10,UI::YELLOW,89,100 #yellow 
#UI.hpbar "PWN",1,7,10,UI::MAGENTA,11,100 #magenta



#UI.cursor :off

#while not STDIN.getch=="q"
#	UI.cls
#	dun=BSPdungeon.new nil,0,0,x.screen_width-1,x.screen_height-1
#end
#dun.dump
#UI.cursor :on

#dun=BSPdungeon.new nil,0,0,x.screen_width-1,x.screen_height-1
#x=Graphicalwindow.new dun
#x.show
screen_height=50
screen_width=50
$dun=BSPdungeon.new screen_width,screen_height, 5
x=Window3d.new




