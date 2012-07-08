#ifndef little_helpers_hpp
#define little_helpers_hpp

#include <cstdlib>

#define vpa(a,b) a->insert(a->end(),b->begin(),b->end())

namespace lil {

  
  
  inline int rand(int low,int high){
    return (std::rand()%((high-low)+1))+low;
  }

  inline int percentof(int self,int x){
    
    return (int)(((float)x/100.0)*(float)self)+0.5;
    
  }
  
  
  
}



#endif
