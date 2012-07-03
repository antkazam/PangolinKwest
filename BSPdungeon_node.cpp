#include "BSPdungeon_node.hpp"

BSPdungeon_node::BSPdungeon_node(BSPdungeon* _dungeon,BSPdungeon_node* _parent,int _x,int _y,int _x2,int _y2)
: x(_x), y(_y), x2(_x2), y2(_y2), parent(_parent), dungeon(_dungeon)
{
  left=nullptr; right=nullptr;
  if(parent==nullptr){ //if parent is null then this is the top level
    depth=1;
  } else {
    depth=parent->depth+1;
  }
  if (depth==dungeon->depth ){
    shrink();
  } else {
    split();
    dungeon->letsjoinlist[depth].push_back( this) ;
  }
  if(parent==nullptr){
    //we are at the top level and the split has been done and recursed all the way down
    //join and complete!
    for(int f=dungeon->depth-1;f>-1;f--){
      for (BSPdungeon_node* g : dungeon->letsjoinlist[f]){
	g->join();
      }
    }
  }
}
   


