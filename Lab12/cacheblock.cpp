#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  uint32_t tag = (_tag) << (_cache_config.get_num_index_bits() + _cache_config.get_num_block_offset_bits());
  uint32_t index = (_index) << _cache_config.get_num_block_offset_bits();
  uint32_t offset = 0;
  uint32_t address = tag | index | offset;
  return address;
}
