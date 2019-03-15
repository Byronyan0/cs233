/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];

	// TODO: write your code here
for(int k = 0; k < length; k = k + 8){
        for(int j = k; j < k + 8; j++){ 
            for(int i = k + 7; i >= k; i--){
                char temp = message_in[i] >> (j - k);
                char a = temp & 0x000000000001;
                message_out[j] += a;
                if(i == k) break;
                message_out[j] = message_out[j] << 1;
            }
        }
    }    








	return message_out;
}
