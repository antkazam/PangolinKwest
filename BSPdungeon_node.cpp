#include "BSPdungeon_node.hpp"
#include "little_helpers.hpp"

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
    for(int f=dungeon->depth-1;f>1;f--){
      for (BSPdungeon_node* g : dungeon->letsjoinlist[f]){
	g->join();
      }
    }
  }
}
   
int BSPdungeon_node::width()
{
  return (x2-x)+1;
}

int BSPdungeon_node::height()
{
  return (y2-y)+1;
}

void BSPdungeon_node::split()
{
  int amount=lil::rand(40,60);
  int choice=lil::rand(1,10);
  
  int pivotx=lil::percentof(amount,width());
  int pivoty=lil::percentof(amount,height());
  
  if(choice<6){
    if(! splithoriz(pivotx)){
      if(! splitvert(pivoty)){
	error_out();
      }
    }
  } else {
    if(! splitvert(pivoty)){
      if(! splithoriz(pivotx)){
	error_out();
      }
    }
  } 
}

bool BSPdungeon_node::splithoriz(int p)
{
 if (   p<4 || (x2-(x+p))<3 || (depth==dungeon->depth-1 && y2-y==(dungeon->height-1))  ){
  return false;
 } else {
  splitdir=HORIZ;
  left=new BSPdungeon_node(dungeon,this,x,y,x+p-1,y2);
  right=new BSPdungeon_node(dungeon,this,x+p,y,x2,y2);
  return true;
 }
}

bool BSPdungeon_node::splitvert(int p)
{
  if (  p<4 || (y2-(y+p))<3 or (depth==dungeon->depth-1 and x2-x==(dungeon->width-1))  ){
    return false;
  } else {
    splitdir=VERT;
    left=new BSPdungeon_node(dungeon,this,x,y,x2,y+p-1);
    right=new BSPdungeon_node(dungeon,this,x,y+p,x2,y2);
    return true;
  }
}
void BSPdungeon_node::error_out()
{
  cout << "Error" << endl; 
  dump();
  exit(0);
  
}

void BSPdungeon_node::dump()
{
  cout << "depth " << depth << " width " << width() << "height " << height() << "x " << x << "y " << y << "x2 " << x2 << "y2 " << y2 << endl;
  if(left)left->dump();
  if(right)right->dump();
  
}


void BSPdungeon_node::shrink()
{
  int sx(x),sy(y),sx2(x2),sy2(y2);
  x++;y++;x2--;y2--;
  bool shrink_w=lil::rand(1,10)<6?true:false;
  bool shrink_h=lil::rand(1,10)<6?true:false;
  if(width()<3)shrink_w=false;
  if(height()<3)shrink_h=false;
  int width60,height60,delta,leftside,rightside,topside,bottomside;
  int newwidth(0),newheight(0);
  if(shrink_w){
    width60=lil::percentof(0,width());
    if(width60<2)width60=2;
    if(width()-1==width60){
      newwidth=width()-1;
    } else {
      newwidth=lil::rand(width60,width()-1);
    }
    if(! newwidth==0){
      delta=width()-newwidth;
      leftside=lil::rand(0,delta);
      rightside=delta-leftside;
      x+=leftside;
      x2-=rightside;
    }
  }
  if(shrink_h){
    height60=lil::percentof(0,height());
    if(height60<2)height60=2;
    if(height()-1==height60){
      newheight=height()-1;
    } else {
      newheight=lil::rand(height60,height()-1);
    }
    if(! newheight==0){
      delta=height()-newheight;
      topside=lil::rand(0,delta);
      bottomside=delta-topside;
      y+=topside;
      y2-=bottomside;
    }
  }
  drawroom_in_map();
  x=sx;y=sy;x2=sx2;y2=sy2;
}

void BSPdungeon_node::drawroom_in_map()
{ 
  for(int g=y;g<y2+1;g++){
    for(int f=x;f<x2+1;f++){
      dungeon->map[f][g]=ROOM;
    }
  }
  
}	

void BSPdungeon_node::join()
{
  int genesisx,genesisy;
  vector <pair<int,int> > *path;
  if(splitdir==VERT){
    genesisx=lil::rand(x,x2);
    path=shootray(left,genesisx,left->y2,UP);
    if(path!=nullptr){
      filldungeoncorridor(path);
    } else {
      bentjoin(left,genesisx,left->y2,UP);
    }
    path=shootray(right,genesisx,right->y,DOWN);
    if(path!=nullptr){
      filldungeoncorridor(path);
    } else {
      bentjoin(right,genesisx,right->y,DOWN);
    }
  } else { //horiz
    genesisy=lil::rand(y,y2);
    path=shootray(left,left->x2,genesisy,LEFT);
    if(path!=nullptr){
      filldungeoncorridor(path);
    } else {
      bentjoin(left,left->y2,genesisy,LEFT);
    }
    path=shootray(right,right->x,genesisy,RIGHT);
    if(path!=nullptr){
      filldungeoncorridor(path);
    } else {
      bentjoin(right,right->x,genesisy,RIGHT);
    }
  }
}
void BSPdungeon_node::bentjoin(BSPdungeon_node* half, int xx, int yy, direction dir)
{
   vector <pair<int,int> > *path;
   path=shootraystoside(half,xx,yy,dir);
   
   if(path->empty()){
    error_out();
   } else {
    filldungeoncorridor(path);
   }
}

void BSPdungeon_node::filldungeoncorridor(vector< pair< int, int > >* p)
{
  for(auto f: *p){
    dungeon->map[f.first][f.second]=CORRIDOR;
  }
}

vector< pair< int, int > >* BSPdungeon_node::shootray(BSPdungeon_node* half, int startx, int starty, direction dir)
{
  int dx=DIRPAIRS[dir][0]; int dy=DIRPAIRS[dir][1];
  int tx=startx,ty=starty;
  vector<pair<int,int> >* steps=new vector<pair<int,int> >;
  while(true){
    if(  (dx==-1 && tx==half->x) || (dx==1 && tx==half->x2) || (dy==-1 && ty==half->y) || (dy==1 && ty==half->y2)   ){
      return nullptr;
    }
    steps->push_back(make_pair(tx,ty));
    if (  (dx!=1 && tx-1>=half->x && dungeon->map[tx-1][ty]!=NIL) \
			|| (dx!=-1 && tx+1<=half->x2 && dungeon->map[tx+1][ty]!=NIL) \
			|| (dy!=1 && ty-1>=half->y && dungeon->map[tx][ty-1]!=NIL) \
			|| (dy!=-1 && ty+1<=half->y2 && dungeon->map[tx][ty+1]!=NIL)  ) {
				return steps ;
    }
    tx+=dx; ty+=dy;
  }
}

vector< pair< int, int > >* BSPdungeon_node::shootraystoside(BSPdungeon_node* half, int startx, int starty, direction dir)
// follows the same path as "shootray" but instead of checking one square ahead and to sides
// it shoots secondary rays out to each side. Also rather than returning with the first hit, we take all
// hits and return one of them at random. if there are  no paths the return array will be empty rather than
// return false
{
  int dx=DIRPAIRS[dir][0]; int dy=DIRPAIRS[dir][1];
  int tx=startx,ty=starty;
  vector< pair< int, int > >* result;
  vector <vector<pair<int,int> > *>* steps=new vector<vector<pair<int,int> > *>;
  vector<pair<int,int> >* firstel=new vector<pair<int,int> >;
  vector<pair<int,int> >*temp;
  while(true){ //loop for ever!
    if(dx!=0){ //we are going left or right so shoot rays up and down
      //FIXME instead of copying what firstel is, currently each time and adding it, plus result to steps, we could just add result to steps
      //and when we return a random result from steps we could um somehow have saved how many elements were in firstel and add that many on
      //before returning it
      result=shootray(half,tx,ty,UP);if(result!=nullptr){temp=new vector<pair<int,int> >;vpa(temp,firstel);vpa(temp,result);steps->push_back(temp);}
      result=shootray(half,tx,ty,DOWN);if(result!=nullptr){temp=new vector<pair<int,int> >;vpa(temp,firstel);vpa(temp,result);steps->push_back(temp);}
    } else { //we are going up or down so shoot rays left and right
      result=shootray(half,tx,ty,LEFT);if(result!=nullptr){temp=new vector<pair<int,int> >;vpa(temp,firstel);vpa(temp,result);steps->push_back(temp);}
      result=shootray(half,tx,ty,RIGHT);if(result!=nullptr){temp=new vector<pair<int,int> >;vpa(temp,firstel);vpa(temp,result);steps->push_back(temp);}
    }
    //if we got to the edge then return a random path from steps 
    if(  (dx==-1 && tx==half->x) || (dx==1 && tx==half->x2) || (dy==-1 && ty==half->y) || (dy==1 && ty==half->y2)   ){
       return steps->at(lil::rand(0,steps->size()-1));
    }
    //add  current square to firstel, which represents the first line of the L-shaped corridor 
    firstel->push_back(make_pair(tx,ty));
    //move one square further in the direction we are going
    tx+=dx; ty+=dy;
  }
}



