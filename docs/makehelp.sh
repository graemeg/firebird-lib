#!/bin/bash
FBLDOC=FblibHelp
if [ ! -d $FBLDOC ]; then
  mkdir $FBLDOC
fi
pasdoc ../src/FBLDatabase.pas ../src/FBLTransaction.pas ../src/FBLDsql.pas ../src/FBLService.pas ../src/FBLExcept.pas ../src/FBLEvents.pas ../src/FBLMetadata.pas ../src/FBLScript.pas ../src/FBLSimple.pas ../src/FBLParamDsql.pas -N FbLib -T FbLib-docs -E $FBLDOC

