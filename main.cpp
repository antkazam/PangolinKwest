#include <iostream>

#include "BSPdungeon.hpp"

int main(int argc, char **argv) {
    std::cout << "Projekt Pangolin Kwest:" << std::endl;
    
    BSPdungeon x(50,50,5);
    
    for(int f=0;f<50;f++){
      for(int g=0;g<50;g++){
	if(x.map[f][g]==NIL){
	  std::cout << "##" ;
	} else {
	  if(x.map[f][g]==ROOM){
	    std::cout << "  ";
	  } else {
	      std:: cout << ".." ;
	  }
	
	}
	
      }
      std::cout << std::endl ;
    }
    
    
    return 0;
}
