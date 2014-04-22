#include "lyparse.h"
#include "aux.h"
#include "context.h"
#include<stdlib.h>

Command* newCommand() {
  return (Command*)malloc(sizeof(Command));
}

void executeCommand(Context context, Command command){
  assert(!isEmpty(command.plottables));
  writeDiff(context, plottables);
  updateContext(context, plottables);
  writeContext(context);
}
