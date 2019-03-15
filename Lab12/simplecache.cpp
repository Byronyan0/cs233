#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	std::vector<SimpleCacheBlock> &setSecond = _cache[index];
	for(SimpleCacheBlock &block:setSecond){
		if(block.valid() == true && block.tag() == tag){
			return block.get_byte(block_offset);
		}
	}
	return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
  std::vector<SimpleCacheBlock> &setSecond = _cache[index];
	for(SimpleCacheBlock &block:setSecond){
		if(block.valid() == false){
			block.replace(tag, data);
			return;
		}
	}
	setSecond[0].replace(tag, data);
}

