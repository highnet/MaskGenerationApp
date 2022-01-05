function re = findlabel(array,index)
if array(index) == index
    re = index;
else
    re = findlabel(array,array(index));
end
end