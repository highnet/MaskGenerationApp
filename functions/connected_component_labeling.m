function [label_img, label_num] = connected_component_labeling(img)
[m, n] = size(img);
s = double(img);
%imshow(mat2gray(s));
temp = zeros(m, n);
label = 1;
ET = [];
for i = 2: m
    for j = 2: n
        if(s(i,j) == 1)
            up = temp(i-1,j);
            left = temp(i,j-1);
            if(up == 0 && left == 0)
                temp(i,j) = label;
                ET(label) = label;
                label = label + 1; 
            elseif(up == 0 || left == 0)
                temp(i,j) = max(up,left);
            elseif(up == left)
                temp(i,j) = up;
            else
                if(up > left)
                    temp(i,j) = left;
                    ET(up) = findlabel(ET, left);
                else
                    temp(i,j) = up;
                    ET(left) = findlabel(ET, up);
                end
            end
        end
    end
end
count = [0];
t = 1;
for i = 1:m
    for j = 1: n
        if(temp(i,j) ~= 0)
            temp(i,j) = ET(temp(i,j));
            for r = 1:t
                if count(r) == temp(i,j)
                    break;
                else if r == t
                        t = t+1;
                        count(t) = temp(i,j);
                    end
                end
            end
        end
    end
end
label_img = temp;
label_num = t - 1;
end