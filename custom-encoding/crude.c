/* A crude Dargent example
 *
 * 1. It searches a (disk) block that contains entries of varying
 * length.
 * 2. It returns a structure from a function.
 * 3. It points to a structure within a structure.
 * 4. It does pointer arithmetic.
 *
 *
 */
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

#define SIZE 4096
#define VALUE 42 // Special value we want to find.

struct Stuff { // The data to be ignored
  int a,b,c;
};

struct Entry {
  int id; // what cogent:
  struct Stuff stuff; // (i) knows nothing of
  int value; // (ii) cares about
};

char block[SIZE]; // Contains Entry’s jammed together.

/* Look for Entry with the specified value. */
struct Entry *find_entry(int value) {
  struct Entry *e = (struct Entry *)&block;
  for (;;) {
    if (((uintptr_t)e - (uintptr_t)block) >= SIZE)
      break;
    if (value == e->value)
      return e;
    e = (struct Entry *) ((uintptr_t)e + sizeof(*e));
  }
  return NULL;
}

/* Initialise our block of entries. */
/* Not translated into Cogent. */
void init(void) {
  FILE *fp;
  struct Entry *e;
  int a, b, c, id, v;
  char buf[80];

  memset(block, 0, SIZE);

  if ((fp = fopen("entries.txt", "r")) != NULL) {
    e = (struct Entry *)block;
    id = 0;
    while (fscanf(fp, "%d%d%d%d\n", &a, &b, &c, &v) == 4) {
      if (((uintptr_t)e - (uintptr_t)block) >= SIZE)
        break;
      e->id = id++;
      e->stuff.a = a;
      e->stuff.b = b;
      e->stuff.c = c;
      e->value = v;
      e = (struct Entry *) ((uintptr_t)e + sizeof(*e));
    }
    fclose(fp);
  }
}

int main() { // Print "b" attribute of Entry with VALUE, if present.
  struct Entry *e;
  init();
  e = find_entry(VALUE);
  if (e)
    printf("Entry (%lu) #%d has value %d and b is %d.\n", sizeof(*e),
           e->id, VALUE, e->stuff.b);
  else
    printf("No entry with value %d was found.\n", VALUE);
  return 0;
}
