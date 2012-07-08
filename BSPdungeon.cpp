//C++ Implementation of the BSP dungeon class originally in ruby
// 30 June 2012 (last day of the half year)
#include <iostream>
using std::cout;
using std::endl;






#include "BSPdungeon.hpp"
#include "BSPdungeon_node.hpp"



BSPdungeon::BSPdungeon(int _width, int _height, int _max_depth)
: width(_width), height(_height), depth(_max_depth)
{
  letsjoinlist.resize(depth);
  map.resize(height);
  for (auto &f : map){
    f.resize(width);
  }
  nodes=new BSPdungeon_node(this,nullptr,0,0,width-1,height-1);
}

void BSPdungeon::show_to_console()
{
 for(int f=0;f<50;f++){
      for(int g=0;g<50;g++){
	if(map[f][g]==NIL){
	  std::cout << "##" ;
	} else {
	  if(map[f][g]==ROOM){
	    std::cout << "  ";
	  } else {
	      std:: cout << ".." ;
	  }
	
	}
	
      }
      std::cout << std::endl ;
    }
}