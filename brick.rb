#added 16 June

require 'opengl'
include Gl,Glu,Glut
require 'RMagick'

$rotl = 1 * Math::PI / 180
$last_time = 0

$fXDiff =-7 # 206
$fYDiff = 159# 16
$fZDiff = -7 # 10
$xLastIncr = 0
$yLastIncr = 0
$fXInertia = -0.5
$fYInertia = 0
$fXInertiaOld = 0
$fYInertiaOld = 0
$fScale = 0.15
$ftime = 0
$xLast = -1
$yLast = -1
$bmModifiers = 0
$rotate = false

$playerx, $playery=0, 0

INERTIA_THRESHOLD = 1.0
INERTIA_FACTOR = 0.5
SCALE_FACTOR = 0.01
SCALE_INCREMENT = 0.5
TIMER_FREQUENCY_MILLIS = 20



#$clearColor = [[0,0,0,1], [0.2,0.2,0.3,1], [0.7,0.7,0.7,1]]


def arbcube x, y, z, w, h,zh, t,tx2,ty2
    sx=x-1                #$dun.x-1
   sx2=(x+w)*2          #($dun.x2)*2
   sy=y-1               #$dun.y-1
   sy2=(y+h)*2          #($dun.y2)*2
   
   sx2+=1 ; sy2+=1
   
   sz=z
   sz2=(z+zh)*2
    # sizey=20
    # sizez=0
	#delta = 0.3

	v= [
		[ sx2,  sy2,  sz2 ],  # sizez * scale + delta 
		[ sx2,  sy2, sz ], # -sizez * scale + delta
		[ sx2, sy, sz ], # -sizez * scale
		[ sx2, sy, sz2 ], #   sizez * scale
		[sx,  sy2,  sz2 ], # sizez * scale + delta
		[sx,  sy2, sz ], #  -sizez * scale + delta
		[sx, sy, sz ], #  -sizez * scale
		[sx, sy, sz2 ] #  sizez * scale
	]

	cube = [
		[ [1,0,0], v[3],v[2],v[1],v[0] ], # normal, vertices
		[ [-1,0,0], v[6],v[7],v[4],v[5] ],
		[ [0,0,-1], v[2],v[6],v[5],v[1] ],
		[ [0,0,1], v[7],v[3],v[0],v[4] ],
		[ [0,1,0], v[4],v[0],v[1],v[5] ],
		[ [0,-1,0], v[6],v[2],v[3],v[7] ]
	]
   glBindTexture GL_TEXTURE_2D, $textures[t]
   #glEnable GL_CULL_FACE
        glBegin(GL_QUADS)
        
          
          
        cube.each do |side|
            #loop through sides, magnifying it to fit the whole dungeon
                glNormal3fv(side[0])
            #glNormal3fv cube[0][0]
                glTexCoord2f(tx2,ty2)
                glVertex3fv(side[1])
                glTexCoord2f(0,ty2)
                glVertex3fv(side[2])
                glTexCoord2f(0,0)
                glVertex3fv(side[3])
                glTexCoord2f(tx2,0)
                glVertex3fv(side[4])
			end
    glEnd 
end

def drawCube
	size = 1.0
	scale = 2.0
	delta = 0.0

	v = [
		[ size,  size,  size * scale + delta ], 
		[ size,  size, -size * scale + delta ], 
		[ size, -size, -size * scale ], 
		[ size, -size,  size * scale ],
		[-size,  size,  size * scale + delta ],
		[-size,  size, -size * scale + delta ],
		[-size, -size, -size * scale ],
		[-size, -size,  size * scale ]
	]

	cube = [
		[ [1,0,0], v[3],v[2],v[1],v[0] ], # normal, vertices
		[ [-1,0,0], v[6],v[7],v[4],v[5] ],
		[ [0,0,-1], v[2],v[6],v[5],v[1] ],
		[ [0,0,1], v[7],v[3],v[0],v[4] ],
		[ [0,1,0], v[4],v[0],v[1],v[5] ],
		[ [0,-1,0], v[6],v[2],v[3],v[7] ]
	]
    
   sx=-1 #dun.x-1
   sx2=($dun.width-1)*2
   sy=-1 #dun.y-1
   sy2=($dun.height-1)*2
   
   sx2+=1 ; sy2+=1
   
   sz=2
   sz2=4
   sizey=20
   sizez=0
   
	
	delta = 0.3

	v= [
		[ sx2,  sy2,  sz2 ],  # sizez * scale + delta 
		[ sx2,  sy2, sz ], # -sizez * scale + delta
		[ sx2, sy, sz ], # -sizez * scale
		[ sx2, sy, sz2 ], #   sizez * scale
		[sx,  sy2,  sz2 ], # sizez * scale + delta
		[sx,  sy2, sz ], #  -sizez * scale + delta
		[sx, sy, sz ], #  -sizez * scale
		[sx, sy, sz2 ] #  sizez * scale
	]

	cube_floor = [
		[ [1,0,0], v[3],v[2],v[1],v[0] ], # normal, vertices
		[ [-1,0,0], v[6],v[7],v[4],v[5] ],
		[ [0,0,-1], v[2],v[6],v[5],v[1] ],
		[ [0,0,1], v[7],v[3],v[0],v[4] ],
		[ [0,1,0], v[4],v[0],v[1],v[5] ],
		[ [0,-1,0], v[6],v[2],v[3],v[7] ]
	]
    
        #glMatrixMode GL_MODELVIEW  
    #move player
    
    
    glTranslatef -($playerx*2).to_f, -($playery*2).to_f, 0
     
       
 
     # glutSolidSphere 10, 4, 4
    
      #glutSolidTeapot 1
    
    glBindTexture GL_TEXTURE_2D, $textures[0]
	glBegin(GL_QUADS)
    
    
		$manycuebs.each do |cueb|
					
			cueb.each do |side|
				glNormal3fv(side[0])
				#glNormal3fv cube[0][0]
				glTexCoord2f(1,3)
				glVertex3fv(side[1])
				glTexCoord2f(0,3)
				glVertex3fv(side[2])
				glTexCoord2f(0,0)
				glVertex3fv(side[3])
				glTexCoord2f(1,0)
				glVertex3fv(side[4])
			end
		end		
	glEnd()
    
    if false 
        #draw floor
       glBindTexture GL_TEXTURE_2D, $textures[1] #floor texture
        glBegin(GL_QUADS)
        cube_floor.each do |side|
            #loop through sides, magnifying it to fit the whole dungeon
                glNormal3fv(side[0])
            #glNormal3fv cube[0][0]
                glTexCoord2f($dun.x2,$dun.y2)
                glVertex3fv(side[1])
                glTexCoord2f(0,$dun.y2)
                glVertex3fv(side[2])
                glTexCoord2f(0,0)
                glVertex3fv(side[3])
                glTexCoord2f($dun.x2,0)
                glVertex3fv(side[4])
			end
    glEnd
    end # if false
    
    arbcube 0,0,2,$dun.width-1,$dun.height-1,0,1,$dun.width-1,$dun.height-1
    
    glFrontFace GL_CW
    arbcube 0,0,-3,$dun.width-1,$dun.height-1,0,1,$dun.width-1,$dun.height-1
    glFrontFace GL_CCW
    
       # glMatrixMode GL_MODELVIEW no point we're already on it
     
               glTranslatef ($playerx*2).to_f, ($playery*2).to_f, 0
       
        #glutSolidSphere 1, 10, 10

   
          glBindTexture GL_TEXTURE_2D, $textures[2]   
            glutSolidIcosahedron
        # glutSolidTeapot 1
end








class Window3d 
	def initialize
	# Main



play = lambda do
	this_time = glutGet(GLUT_ELAPSED_TIME)

	$rotl+=(this_time - $last_time) * -0.001
	$last_time = this_time

	glutPostRedisplay()
end


display = lambda do
	glLoadIdentity()
	glTranslatef(0.0, 0.0, -5)
	
	glRotatef($fYDiff, 1,0,0)
	glRotatef($fXDiff, 0,1,0)
	glRotatef($fZDiff, 0,0,1)
	
	glScalef($fScale, $fScale, $fScale)
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	
    drawCube # BAM!
    
	glFlush()
	glutSwapBuffers()
end

key = lambda do |key,x,y|
	case(key)
	when ?b
		nextClearColor()
	when ?q, ?\e # esc
		exit(0)
	when ?t
		$gleModel << $gleModel.shift # rotate the array
	when ?\s # space
		$rotate = !$rotate

		if ($rotate==false)
			$fXInertiaOld = $fXInertia
			$fYInertiaOld = $fYInertia
		else
			$fXInertia = $fXInertiaOld
			$fYInertia = $fYInertiaOld

      # To prevent confusion, force some rotation
			if ($fXInertia == 0 && $fYInertia == 0)
				$fXInertia = -0.5
			end
		end
	when ?+
		$fScale += SCALE_INCREMENT
	when ?-
		$fScale -= SCALE_INCREMENT
	else
		puts "Keyboard commands:\n"
		puts "q, <esc> - Quit"
		puts "<home>                            = reset zoom and rotation"
		puts "left button and maus              = piss around with view"
        puts "ctrl and left button and maus     =piss around more, including zoom"
        puts "<arrow keys>                      =moob pangolin\n"
	end
end


reshape = lambda do |w,h|
	vp = 0.8
	aspect = w.to_f/h.to_f
	
	glViewport 0, 0, w, h
	glMatrixMode GL_PROJECTION
	glLoadIdentity
	
	glFrustum -vp, vp, -vp / aspect, vp / aspect, 1, 100 #1 is zmin, 100 is zmax. both must be positive
	
	glMatrixMode GL_MODELVIEW
	glLoadIdentity
	glTranslatef 0.0, 0.0, -5.0 
end


motion = lambda do |x,y|
	if ($xLast != -1 || $yLast != -1)
		$xLastIncr = x - $xLast
		$yLastIncr = y - $yLast
		if ($bmModifiers & GLUT_ACTIVE_CTRL != 0)
			if ($xLast != -1)
				$fZDiff += $xLastIncr
				$fScale += $yLastIncr*SCALE_FACTOR
			end
		else
			if ($xLast != -1)
				$fXDiff += $xLastIncr
				$fYDiff += $yLastIncr
			end
		end
	end
	$xLast = x
	$yLast = y
end


mouse = lambda do |button,state,x,y|
	$bmModifiers = glutGetModifiers()
	if (button == GLUT_LEFT_BUTTON)
		if (state == GLUT_UP)
			$xLast = -1
			$yLast = -1
			if $xLastIncr > INERTIA_THRESHOLD
				$fXInertia = ($xLastIncr - INERTIA_THRESHOLD)*INERTIA_FACTOR
			end
			if -$xLastIncr > INERTIA_THRESHOLD
				$fXInertia = ($xLastIncr + INERTIA_THRESHOLD)*INERTIA_FACTOR
			end

			if $yLastIncr > INERTIA_THRESHOLD
				$fYInertia = ($yLastIncr - INERTIA_THRESHOLD)*INERTIA_FACTOR
			end
			if -$yLastIncr > INERTIA_THRESHOLD
				$fYInertia = ($yLastIncr + INERTIA_THRESHOLD)*INERTIA_FACTOR
			end
		else
			$fXInertia = 0
			$fYInertia = 0
		end
		$xLastIncr = 0
		$yLastIncr = 0
	end
end


special = lambda do |key,x,y|
	case key
	when GLUT_KEY_HOME
		puts "here: #{$fXDiff} #{$fYDiff} #{$fZDiff} #{$fScale}"
        $fXDiff = -7
		$fYDiff = 159
		$fZDiff = -7
		$xLastIncr = 0
		$yLastIncr = 0
		$fXInertia = -0.5
		$fYInertia = 0
		$fScale = 0.15
	when GLUT_KEY_LEFT
        if $dun.map[$playerx-1, $playery]!=nil
            $playerx-=1; #print "#{$playerx}  #{$playery} " ; p  $dun.map[$playerx, $playery]
        end
	when GLUT_KEY_RIGHT
		if $dun.map[$playerx+1, $playery]!=nil
            $playerx+=1; #print "#{$playerx}  #{$playery} " ; p  $dun.map[$playerx, $playery]
        end
	when GLUT_KEY_UP
        	if $dun.map[$playerx, $playery-1]!=nil
                $playery-=1; #print "#{$playerx}  #{$playery} " ; p  $dun.map[$playerx, $playery]
            end
	when GLUT_KEY_DOWN
        if $dun.map[$playerx, $playery+1]!=nil
            $playery+=1; #print "#{$playerx}  #{$playery} " ; p  $dun.map[$playerx, $playery]
        end
	end
end

timer = lambda do |value|
	$ftime += 0.01
	if $rotate
		$fXDiff += $fXInertia
		$fYDiff += $fYInertia
	end
	glutTimerFunc(TIMER_FREQUENCY_MILLIS , timer, 0)
end








		glutInit()
		glutInitDisplayMode( GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE)
		glutInitWindowPosition(100,100)
		glutInitWindowSize(800, 600)
		glutCreateWindow( "Pangolin Kwest 3d")

		glutIdleFunc(play)
		glutDisplayFunc(display)
		glutKeyboardFunc(key)
		glutReshapeFunc(reshape)
		glutMotionFunc(motion)
		glutMouseFunc(mouse)
		glutSpecialFunc(special)
		glutTimerFunc(TIMER_FREQUENCY_MILLIS , timer, 0)
		 
		# Make sure that OpenGL 2.0 is supported by the driver 
		#graspee's slaptop has teh 3.3
		if Gl.is_available?(2.0)==false
			major,minor,*rest = glGetString(GL_VERSION).split(/\.| /)
			puts "GL_VERSION major=#{major} minor=#{minor}"
			puts "Support for OpenGL 2.0 is required for this demo...exiting"
			exit(1)
		end
	
		makedungeoncuebs
        
        glEnable GL_TEXTURE_2D #tex mapping on
        glShadeModel GL_SMOOTH #smooth shading on
        glClearDepth 1.0 #depth buffer setup
		glDepthFunc(GL_LESS) # GL_LEQUAL in nehe 7
		glEnable(GL_DEPTH_TEST)
        #glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST #nicest perspective calcs (from nehe 7)
        
        @ambient = [1.0, 1.0, 1.0, 1.0]
        @diffuse = [1.0, 1.0, 1.0, 1.0]
        @light_position = [0.0, 0.0, 0.0, 42.0] #these prolly don't need to be @s or maybe need to be globals
        
        glEnable GL_LIGHTING
        
        glLightfv GL_LIGHT1, GL_AMBIENT, @ambient
        glLightfv GL_LIGHT1, GL_DIFFUSE, @diffuse
        glLightfv GL_LIGHT1, GL_POSITION, @light_position
        
        glLightfv GL_LIGHT1, GL_SPOT_EXPONENT,  [0.01]
        #specular?
        glEnable GL_LIGHT1
        glEnable GL_CULL_FACE
        glFrontFace GL_CCW
		#nextClearColor()
		key.call('?', 0, 0)	 
        inittextures
        
        placeplayer
        
		glutMainLoop
	end
end
def makedungeoncuebs
	size = 1.0
	scale = 3.0
	delta = 0.0
	v = [
		[ size,  size,  size * scale + delta ], 
		[ size,  size, -size * scale + delta ], 
		[ size, -size, -size * scale ], 
		[ size, -size,  size * scale ],
		[-size,  size,  size * scale + delta ],
		[-size,  size, -size * scale + delta ],
		[-size, -size, -size * scale ],
		[-size, -size,  size * scale ]
	]
	cube = [
		[ [1,0,0], v[3],v[2],v[1],v[0] ], 
		[ [-1,0,0], v[6],v[7],v[4],v[5] ],
		[ [0,0,-1], v[2],v[6],v[5],v[1] ],
		[ [0,0,1], v[7],v[3],v[0],v[4] ],
		[ [0,1,0], v[4],v[0],v[1],v[5] ],
		[ [0,-1,0], v[6],v[2],v[3],v[7] ]
	]
	
		$manycuebs=[]
		(0..$dun.width-1).each do |x|
			(0..$dun.height-1).each do |y|
				#xx=x-($dun.x2/2) ; yy=y-($dun.y2/2)
				#xx=(xx*2).to_f ; yy=(yy*2).to_f				
                
                xx=(x*2).to_f ; yy=(y*2).to_f
                
				newcueb=[]
				if $dun.map[x,y]==nil
				#if $manycuebs.length<3
					cube.each do |side| #each side has 0 to 4 triples
						newside=[]						
						side.each do |triple|
							#newside << [ triple[0]*xx,triple[1]*yy,triple[2] ] 
							newside << [ triple[0]+xx,triple[1]+yy,triple[2] ] 
						end
						newcueb << newside 
						
					end
					$manycuebs << newcueb 
				end
			end	
		end		
        
end



def inittextures
    $textures=glGenTextures 3 # total number of textures
    #loadtexture 0, "Purple.png"
   loadtexture 0, "media/stdwall.jpg" 
   loadtexture 1, "media/stdfloor.jpg"
    loadtexture 2, "media/firefloor.jpg"
    #loadtexture 1, "Blue.png"
  #  loadtexture 2, "Red.png" #red one just doesn't want to load

    
    
    
    
    #we no has mipmapz
    #gluBuild2DMipmaps GL_TEXTURE_2D, GL_RGBA, width, height, GL_RGBA, GL_UNSIGNED_BYTE, image

end
def loadtexture number, name
   
   
png=Magick::ImageList.new name
height=512 ; width =512
image=png.to_blob {self.format="rgba"}


    glBindTexture GL_TEXTURE_2D, $textures[number]

    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
   
end

def placeplayer
    
    while $dun.map[$playerx, $playery]==nil
    $playerx=rand 0...$dun.width
    $playery=rand 0...$dun.height
    end
    

end
