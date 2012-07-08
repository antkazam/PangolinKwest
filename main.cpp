#include <iostream>

#include "BSPdungeon.hpp"


#include <irrlicht/irrlicht.h>
using namespace irr;
using namespace core;
using namespace scene;
using namespace video;
using namespace io;
using namespace gui;

#ifdef _IRR_WINDOWS_
#pragma comment(lib, "Irrlicht.lib")
#pragma comment(linker, "/subsystem:windows /ENTRY:mainCRTStartup")
#endif


int main(int argc, char **argv) {
    BSPdungeon dun(50,50,5);
    
   IrrlichtDevice *device =createDevice( video::EDT_OPENGL, dimension2d<u32>(640, 480), 16,false, false, false, 0);

	if (!device)
		return 1;

	device->setWindowCaption(L"Hello World! - Irrlicht Engine Demo");

	
	IVideoDriver* driver = device->getVideoDriver();
	ISceneManager* smgr = device->getSceneManager();
	IGUIEnvironment* guienv = device->getGUIEnvironment();

	guienv->addStaticText(L"Pangolin Kwest 3D",
		rect<s32>(10,10,260,22), true);
	//-------------------------------------------	
	
	int x,y;
	for(x=0;x<50;x++){
		for(y=0;y<50;y++){
		  if(dun.map[x][y]==NIL){
		    ISceneNode* cueb=smgr->addCubeSceneNode(10);
		    cueb->setMaterialFlag(EMF_LIGHTING, false);
		    cueb->setMaterialTexture( 0, driver->getTexture("stdwall.jpg") );
		    cueb->setPosition(vector3df(x*10,0,y*10));
		  }
		}
	}	

	



	//-------------------------------------------	



	//smgr->addCameraSceneNode(0, vector3df(0,30,-40), vector3df(0,5,0));
	smgr->addCameraSceneNodeFPS();
	
	while(device->run())
	{
		
		driver->beginScene(true, true, SColor(255,100,101,140));

		smgr->drawAll();
		guienv->drawAll();

		driver->endScene();
	}

	
	device->drop();

    
    
    
    
    
    
    return 0;
}
