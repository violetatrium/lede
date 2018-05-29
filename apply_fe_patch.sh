#!/bin/bash

for i in $( ls patches ); do
	echo Applying patch $i
	patch -p1 < patches/$i
done
