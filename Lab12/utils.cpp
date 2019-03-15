#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  uint32_t index_length = cache_config.get_num_index_bits();
  uint32_t offset_length = cache_config.get_num_block_offset_bits(); 
  return address >> (index_length + offset_length);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  uint32_t index_length = cache_config.get_num_index_bits();
  uint32_t offset_length = cache_config.get_num_block_offset_bits();
  int mask = ((1 << index_length) - 1) << offset_length;
  return (address & mask) >> offset_length;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  uint32_t offset_length = cache_config.get_num_block_offset_bits();
  int mask = (1 << offset_length) - 1;
  return address & mask;
}
