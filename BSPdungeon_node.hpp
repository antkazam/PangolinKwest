#ifndef BSPdungeon_node_hpp
#define BSPdungeon_node_hpp

#include "BSPdungeon.hpp"

enum direction { UP,DOWN,LEFT,RIGHT };
const int DIRPAIRS [4][2] ={{0,-1},{0,1},{-1,0},{1,0}};

enum splitDirType { HORIZ, VERT };


class BSPdungeon_node{
public:
  BSPdungeon* dungeon; 
  BSPdungeon_node *parent,*left,*right;
  int depth,x,y,x2,y2;
  splitDirType splitdir;
  
  BSPdungeon_node(BSPdungeon* _dungeon,BSPdungeon_node* _parent,int _x,int _y,int _x2,int _y2);
  void shrink(){}
  void split(){}
  void join(){}
};

#endif
