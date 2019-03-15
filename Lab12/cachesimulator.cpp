#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
   vector<Cache::Block*> blocks = _cache->get_blocks_in_set(extract_index(address, _cache->get_config()));
   for(Cache::Block* block: blocks){
      _use_clock++;      
      if(block->is_valid() && (block->get_tag() == extract_tag(address, _cache->get_config()))){
      _hits++;
      return block;
      }				
   }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
	CacheConfig cacheconfig = _cache->get_config();
	uint32_t i = extract_index(address, cacheconfig);
	uint32_t tag = extract_tag(address, cacheconfig);
	vector<Cache::Block*> blocks = _cache->get_blocks_in_set(i);
	Cache::Block* lru = blocks[0];
	for(auto block: blocks)
    {
		_use_clock++;
		// find LRU Block here
		if(!block->is_valid())
		{
			block->set_tag(tag);
			block->read_data_from_memory(_memory);
			block->mark_as_valid();
			block->mark_as_clean();
			return block;
		}
		if (block->get_last_used_time() < lru->get_last_used_time()) 
			lru = block;				
	}
	if(lru->is_dirty())
		lru->write_data_to_memory(_memory);
	lru->set_tag(tag);
	lru->read_data_from_memory(_memory);
	lru->mark_as_valid();
	lru->mark_as_clean();
	return lru;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
	Cache::Block* block = find_block(address);
	if(block == NULL){
		block = bring_block_into_cache(address);
	}

	block->set_last_used_time(_use_clock.get_count());
	return block->read_word_at_offset(extract_block_offset(address, _cache->get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */

	Cache::Block* block = find_block(address);
	if(block == NULL)
	{
		if(_policy.is_write_allocate())
		{
			block = bring_block_into_cache(address);
		}
		else
		{
			_memory->write_word(address, word);
			return;
		}
	}
	block->set_last_used_time(_use_clock.get_count());
	block->write_word_at_offset(word, extract_block_offset(address, _cache->get_config()));
	if(_policy.is_write_back()){
		block->mark_as_dirty();
	}
	else{
		_memory->write_word(address, word);
	}
}
