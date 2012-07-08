#ifndef BSPdungeon_hpp
#define BSPdungeon_hpp


#include <vector>
using std::vector;

enum mapTileType { NIL, CORRIDOR, ROOM, DOOR };

//#include "BSPdungeon_node.hpp"

class BSPdungeon_node;
//class BSPdungeon;



class BSPdungeon {
public:
  vector<vector<mapTileType> > map;
  int width, height, depth;
  vector < vector <BSPdungeon_node*>> letsjoinlist;
  BSPdungeon_node* nodes;
  BSPdungeon(int _width,int _height,int _max_depth);
  void show_to_console();
};


#endif