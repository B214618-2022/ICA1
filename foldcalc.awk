#!usr/bin/awk
{
diff=$1-$2;
if ( $1 == 0 ) fold=0;
else if ( $2 == 0) fold=0;
else fold=diff/$2;

print fold;
}
