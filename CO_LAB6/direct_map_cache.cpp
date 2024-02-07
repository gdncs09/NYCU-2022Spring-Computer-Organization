#include <iostream>
#include <fstream>
#include <cstring>
#include <cmath>
#include <getopt.h>
#include <vector>
#define K 1024

struct cache_content {
          bool v;
          unsigned int tag;
//    unsigned int data[16];
};

static void simulate(int cache_size, int block_size, int asso, char *test_file_name) {
          std::ifstream fp(test_file_name);

          if(!fp.is_open()) {
                    std::cerr << "Test file doesn't exist\n";
                    return;
          }

          unsigned tag, index, x;

          int offset_bit = (int)std::log2(block_size);
          int index_bit = (int)std::log2(cache_size / block_size);
          int line = cache_size >> offset_bit;
          std::cout << "cache line:" << line << std::endl;

          /*
          cache_content *cache = new cache_content[line];
          for (int j = 0; j < line; j++)
                    cache[j].v = false;
                    */

          std::vector<std::vector<unsigned int>> cache(line);
          double count_hit = 0, total = 0;
          std::vector<int> instr(1);
          while (fp >> std::hex >> x) {
                    total++;
                    //std::cout << std::hex << x << " ";
                    index = (x >> offset_bit) & (line - 1);
                    tag = x >> (index_bit + offset_bit);

                    /*if (cache[index].v && cache[index].tag == tag) {
                              cache[index].v = true;    //hit
                              instr.push_back(1);
                              hit++;
                    }
                    else {
                              cache[index].v = true;    //miss
                              cache[index].tag = tag;
                              instr.push_back(0);
                    }*/

                    bool hit = false;
                    for (int i = 0; i < cache[index].size(); i++)
                    {
                              if (cache[index][i] == tag)
                              {
                                        cache[index].erase(cache[index].begin()+i);
                                        cache[index].insert(cache[index].begin(), tag);
                                        hit = true;
                                        instr.push_back(1);
                                        count_hit++;
                                        break;
                              }
                    }
                    if (!hit)
                    {
                              if (cache[index].size() == asso)
                                        cache[index].erase(cache[index].begin()+asso-1);
                              cache[index].insert(cache[index].begin(), tag);
                              instr.push_back(0);
                    }
          }
          std::cout << std::endl;
          //Output
          //std::cout << "Cache size: " << cache_size/K <<"KB" << std::endl;
          //std::cout << "Block size: " << block_size << "B" << std::endl;
          std::cout << "Miss rate: " << ((total-count_hit)/total)*100 << std::endl;
          int count;

          std::cout << "Hit instructions: ";
          count = 0;
          for (int i = 1; i <= total; i++)
                    if (instr[i]==1)
                    {
                              count++;
                              if (count > 1)
                                        std::cout << ",";
                              std::cout << std::dec << i;
                    }
          std::cout << std::endl;
          std::cout << "Miss instructions: ";
          count = 0;
          for (int i = 1; i <= total; i++)

                    if (instr[i]==0)
                    {
                              count++;
                              if (count > 1)
                                        std::cout << ",";
                              std::cout << std::dec << i;
                    }
          /*----------------------------------------------------*/
          fp.close();
          //delete[] cache;
}

int main(int argc, char **argv, char **envp) {
    char test_file_name[1024];
    int cache_size = 1; //4KB
    int block_size = 16; //16B
    int associativity = 1;
    int current_option;
    while ((current_option = getopt(argc, argv, "f:c:b:a:")) != EOF) {
        switch (current_option) {
            case 'f': {
				strcpy(test_file_name, optarg);
                break;
            }
            case 'c': {
                cache_size = atoi(optarg);
                break;
            }
            case 'b': {
                block_size = atoi(optarg);
                break;
            }
            case 'a': {
                associativity = atoi(optarg);
                break;
            }
			default: {
				std::cerr << "invalid option";
				exit(1);
			}
        }
    }

    // default simulate 4KB direct map cache with 16B blocks
    simulate(cache_size * K, block_size, associativity, test_file_name);
}
