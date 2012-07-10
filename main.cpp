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
    
   IrrlichtDevice *device =createDevice( video::EDT_OPENGL, dimension2d<u32>(1280,720), 16,false, false, false, 0);

	if (!device)
		return 1;

	device->setWindowCaption(L"Pangolin Kwest");

	
	IVideoDriver* driver = device->getVideoDriver();
	ISceneManager* smgr = device->getSceneManager();
	IGUIEnvironment* guienv = device->getGUIEnvironment();
	
	smgr->setAmbientLight(video::SColorf(0.1,0.1,0.1,1));
	
	ILightSceneNode* mylight1 = smgr->addLightSceneNode( 0, core::vector3df(00,00,00), video::SColorf(0.3f,0.3f,0.3f), 30.0f, 1 ); 
	
	//IGUIFont* myfont=guienv->getFont("./myfont.xml");
	//if(myfont==0)exit(93);
	
	//guienv->addMessageBox(L"Alertz!",L"You pangolin are been createrized. You totalleh ready to bash monstaz etc.!");
	
	mylight1->enableCastShadow(true);
	
	//guienv->addStaticText(L"Pangolin Kwest 3D",rect<s32>(10,10,260,22), true);
	//-------------------------------------------	
	
	int x,y,z;
	for(x=0;x<50;x++){
		for(y=0;y<50;y++){
		  if(dun.map[x][y]==NIL){
		    for(z=0;z<3;z++){
		      ISceneNode* cueb=smgr->addCubeSceneNode(10);
		      cueb->setMaterialFlag(EMF_LIGHTING, true);
		      cueb->setMaterialTexture( 0, driver->getTexture("media/stdwall.jpg") );
		     // cueb->getMaterial(0).getTextureMatrix(0).setTextureTranslate(0.25,0.5);
		     // cueb->getMaterial(0).getTextureMatrix(0).setTextureScale(0.0625,0.0625);
		      cueb->setPosition(vector3df(x*10,z*10,y*10));
		    }
		  }
// 		   ISceneNode* cueb=smgr->addCubeSceneNode(10);
// 		   cueb->setMaterialFlag(EMF_LIGHTING, true);
// 		   cueb->setMaterialTexture( 0, driver->getTexture("media/stdfloor.jpg") );
// 		   cueb->setPosition(vector3df(x*10,-10,y*10));
		   
		   ISceneNode* cueb=smgr->addCubeSceneNode(10);
		   cueb->setMaterialFlag(EMF_LIGHTING, true);
		   cueb->setMaterialTexture( 0, driver->getTexture("media/stdup.jpg") );
		   cueb->setPosition(vector3df(x*10,30,y*10));
		   
		}
	}	

	
	
	ISceneNode* cueb=smgr->addCubeSceneNode(500);
	cueb->setMaterialFlag(EMF_LIGHTING, true);
	cueb->setMaterialTexture( 0, driver->getTexture("media/stdfloor.jpg") );
	cueb->setPosition(vector3df(250,-255,250));
	//cueb->getMaterial(0).getTextureMatrix(0).setTextureTranslate(0.25,0.5);
	cueb->getMaterial(0).getTextureMatrix(0).setTextureScale(50,50);
	//cueb->setScale(vector3df(0,-5,0));
	 //cueb->addshadowVolumeSceneNode();



	//-------------------------------------------	

	int lastFPS;

	//smgr->addCameraSceneNode(0, vector3df(0,30,-40), vector3df(0,5,0));
	ICameraSceneNode* mycam;
	mycam=smgr->addCameraSceneNodeFPS(0,100.0f,0.025f);
	mycam->setFOV(45);
	mylight1->setParent(mycam);
	while(device->run())
	{
		//mylight1->setPosition();
		//mylight1->
		driver->beginScene(true, true, SColor(255,100,101,140));
  
		smgr->drawAll();
		guienv->drawAll();

		driver->endScene();
		
		int fps = driver->getFPS();

                if (lastFPS != fps)
                {
                        core::stringw str = L"Pangolin Kwest 3D [";
                        str += driver->getName();
                        str += "] FPS:";
                        str += fps;

                        device->setWindowCaption(str.c_str());
                        lastFPS = fps;
                }
		
	}

	
	device->drop();

    
    
    
    
    
    
    return 0;
}
