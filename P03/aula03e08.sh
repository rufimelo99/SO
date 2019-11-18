#!/bin/bash
# select structure to create menus
select arg in $@; do 
if [[ $arg != $@ ]]; then
    echo "wrong choice!"

else
    echo "You picked $arg ($REPLY)."
fi

done