function [output] = DT_1D(input, pass)
%Distance transform on a 1 dimensional structure

INF=1000000000000000000000000000000000;

[rows, columns]=size(input);
v = zeros(rows, columns);
output = zeros(rows, columns);
modedInput=input.*pow2(32);

if rows==1
    z = zeros(rows, columns+1);
    n=columns;
else
    z = zeros(rows+1, columns);
    n=rows;
end

k=1;
v(1) = 1;
z(1) = -INF; %negative infinity
z(2) = INF; %positive infinty


for q =2:n
        while true
            s = (((modedInput(q) + q * q) - (modedInput(v(k)) + v(k) * v(k))) / (2 * q - 2 * v(k)));

            if s<=z(k)
                k=k-1;
            else
                break;
            end
        end
        k=k+1;
        v(k) = q;
        z(k) = s;
        z(k+1) = +INF;
end

k = 0;

for q=1:n
    while z(k+1)<q
        k=k+1;
    end
    value=((q-v(k))*(q-v(k)))+modedInput(v(k));

   if pass==1
       output(q)=value;
   end

   if pass==2
       if input(q)>value &&input(q)>1
        output(q)=value;
       else
        output(q)=input(q);
       end
   end
end

end

