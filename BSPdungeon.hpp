#ifndef BSPdungeon_hpp
#define BSPdungeon_hpp


#include <vector>
#include <list>

enum mapTileType { NIL, CORRIDOR, ROOM, DOOR };

//#include "BSPdungeon_node.hpp"

class BSPdungeon_node;
//class BSPdungeon;



class BSPdungeon {
public:
  std::vector<std::vector<mapTileType> > map;
  int depth,width,height;
  std::vector < std::list <BSPdungeon_node*>> letsjoinlist;
  BSPdungeon_node* nodes;
  BSPdungeon(int _width,int _height,int _max_depth);
};


#endif