  a=[ 0,0,0,0,0,1,0,1;
      0,1,1,0,0,1,0,1;
      0,0,1,0,0,1,0,1;
      0,0,1,1,0,1,0,1;
      0,0,0,0,0,1,0,1];
  b=zeros(5,5);

disp('////////////////////////////////////');
%Displaying columns (vertical facing thing)
% 
% disp(a);
% disp(b);

% for i=1:5
%    b(:, i)=DT_1D(a(:,i)*pow2(32));
% end
% disp('NEW B:');
% disp(b);

%Displaying rows (horizontal facing thing)

% for i=1:4
%    display(a(i,:));
% end

%testInput=[0, pow2(32), pow2(32),pow2(32), 0,0,0,pow2(32),0];
%testOutput1=DT_1D(testInput);
disp('Input');
disp(a);
disp('complement img')
disp(imcomplement(a))

testOutput2=DT_2F(imcomplement(a));
testOutput3=bwdist(a);
testOutput3=testOutput3.*testOutput3;


disp('output');
disp(testOutput2);


disp('output bwdist');
disp(testOutput3);

disp('////////////////////////////////////');
