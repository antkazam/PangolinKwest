module UI
	
	BLACK=8
    RED=9
    GREEN=10
    YELLOW=11
    BLUE=12
    MAGENTA=13
    CYAN=14
    WHITE=15
    
    def UI.setbg colour
		print "\e[48;5;#{colour}m"
    end
    
    def UI.setfg colour
		print "\e[38;5;#{colour}m"
    end
    
    def UI.normal
		print "\e[0m"
	end
    
    def UI.cls
		print "\e[0m\e[2J\e[0;0H"
	end
    
     def UI.cursor state
		if state==:on then print "\e[?25h" else print "\e[?25l" end
    end
    
    def UI.hpbar text,xpos, ypos, length, colour, current, max
		fullblocksize=max/length
		halfblocksize=fullblocksize/2
		nex=0
		charnex,charmax=0,text.length
	
		#buildup="\e[38;5;0m\e[48;5;#{colour}m\e[#{ypos};#{xpos}H"
		buildup="\e[38;5;0m\e[48;5;#{colour}m".at xpos,ypos
		(0...length).each do |f|
			case 
				when current >= nex+fullblocksize
					buildup+=if charnex<charmax then text[charnex] else ' ' end
				when current >= nex+halfblocksize
					buildup+="\e[48;5;#{colour-8}m"+if charnex<charmax then text[charnex] else ' ' end
				else
					buildup+="\e[48;5;34m"+if charnex<charmax then text[charnex] else ' ' end #177.chr end
		
			end
		nex+=fullblocksize ; charnex+=1
		end
	print buildup
    end
    
    def UI.hpbar_vert
    end
    
    def UI.frame xpos,ypos,length,height,style=:single
    
		colour=((rand*7)+9).to_i
		print "\e[38;5;#{colour-8}m"
		print "\e[48;5;#{colour}m"
		
		case style
			when :single
				print (218.chr+196.chr*(length-2)+191.chr).at xpos,ypos
				(1..height-2).each do |f|
					print (179.chr+" "*(length-2)+179.chr).at xpos,ypos+f
			end
			print (192.chr+196.chr*(length-2)+217.chr).at xpos,ypos+height-1
			when :double
				print (201.chr+205.chr*(length-2)+187.chr).at xpos,ypos
				(1..height-2).each do |f|
					print (186.chr+" "*(length-2)+186.chr).at xpos,ypos+f
			end
			print (200.chr+205.chr*(length-2)+188.chr).at xpos,ypos+height-1
		end
    end
    def UI.filledrect xpos,ypos,length,height,colour
		
		colour=((rand*256)).round
		
		print "\e[48;5;#{colour}m"
		
		(0...height).each do |f|
			print ('.'*length).at xpos,ypos+f
		end
    
    end
    def UI.minimap xpos,ypos,length,height,worldlength,worldheight,viewlength,viewheight,worldxpos,worldypos
    end
    
end 

