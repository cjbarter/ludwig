file
#include <stdio.h>
#include <string.h>


#define FILESYS_SHORT_STRING_LENGTH (10)

void filesys_compress_string(char * dest, char * src, int buff_len) {
  char * l_dest = dest;

  if (strlen(src) > FILESYS_SHORT_STRING_LENGTH) {
    // truncate the string
    int short_offset = FILESYS_SHORT_STRING_LENGTH/3;
    l_dest = stpncpy(l_dest, src, short_offset);
    l_dest = stpcpy(l_dest, "...");
    char * src_tail = src + (strlen(src) - short_offset);
    strncpy(l_dest, src_tail, short_offset);
  } else {
    // just copy to dest
    strcpy(l_dest, src);
  }
}

int main(int argc, char ** argv) {

  char dest[FILESYS_SHORT_STRING_LENGTH] = {0};
  /*                     0         1         2         3         4         5         6         7         */
  char long_src[200]  = "01234567890123456789012345678901234567890123456789012345678901234567890123456789";
  char short_src[200] = "01234567890123456789012345678901234567890123456789";

  filesys_compress_string(&dest[0], long_src, FILESYS_SHORT_STRING_LENGTH);
  printf("result: %ld, %s\n", strlen(dest), dest);

  filesys_compress_string((char *) &dest, short_src, FILESYS_SHORT_STRING_LENGTH);
  printf("result: %ld, %s\n", strlen(dest), dest);

}
