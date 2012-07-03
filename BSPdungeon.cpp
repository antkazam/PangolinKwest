//C++ Implementation of the BSP dungeon class originally in ruby
// 30 June 2012 (last day of the half year)
#include <iostream>
#include <functional>
#include <algorithm>
#include <map>
#include <deque> //need

#include <utility> // for pairs

#include "BSPdungeon.hpp"
#include "BSPdungeon_node.hpp"



BSPdungeon::BSPdungeon(int _width, int _height, int _max_depth)
: width(_width), height(_height), depth(_max_depth)
{
  nodes=new BSPdungeon_node(this,nullptr,0,0,width-1,height-1);
}


