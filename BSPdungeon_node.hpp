#ifndef BSPdungeon_node_hpp
#define BSPdungeon_node_hpp

#include "BSPdungeon.hpp"


#include <utility>
#include <iostream>

using std::pair;
using std::make_pair;
using std::cout;
using std::endl;

enum direction { UP,DOWN,LEFT,RIGHT };
const int DIRPAIRS [4][2] ={{0,-1},{0,1},{-1,0},{1,0}};

enum splitDirType { HORIZ, VERT };


class BSPdungeon_node{
public:
  int depth,x,y,x2,y2;
  BSPdungeon_node *parent;
  BSPdungeon* dungeon; 
  BSPdungeon_node *left,*right;
  
  splitDirType splitdir;
  
  BSPdungeon_node(BSPdungeon* _dungeon,BSPdungeon_node* _parent,int _x,int _y,int _x2,int _y2);
  int width();
  int height();
  void split();
  bool splithoriz(int p);
  bool splitvert(int p);
  void shrink();
  
  void join();
  void drawroom_in_map();
  void error_out();
  void dump();
  void bentjoin(BSPdungeon_node* half, int xx, int yy, direction dir);
  void filldungeoncorridor(vector<pair<int,int> > *p);
  
  vector<pair<int,int> >* shootray(BSPdungeon_node* half, int startx,int starty,direction dir);
  vector<pair<int,int> >* shootraystoside(BSPdungeon_node* half,int startx,int starty,direction dir);
  
};

#endif
