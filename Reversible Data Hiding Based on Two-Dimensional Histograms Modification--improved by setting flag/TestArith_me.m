% TestArith   Test and example of how to use Arith06 and Arith07

%----------------------------------------------------------------------
% Copyright (c) 2000.  Karl Skretting.  All rights reserved.
% Hogskolen in Stavanger (Stavanger University), Signal Processing Group
% Mail:  karl.skretting@tn.his.no   Homepage:  http://www.ux.his.no/~karlsk/
% 
% HISTORY:
% Ver. 1.0  10.04.2001  KS: function made
% Ver. 1.1  28.06.2001  KS: more test signals
%----------------------------------------------------------------------
function [yout,delta]=TestArith_me(x)
%clear all;
TestSeq=4;     % which test sequence to use
%                1: the same as in TestHuff
%                2: quantized DCT coefficients of AR(1) signal
%                3: some test sequences
%                4: some binary test sequences
%                5: ECG signal
% test if Huff06 gives correct result after decompression
TestA6=1;      % test if Arith06 gives correct result after decompression
TestA7=1;      % test if Arith07 gives correct result after decompression
CompareAll=1;  % compare Huff06, Arith06 and Arith07



    xC{1}=x';
xCno=numel(xC);

% if TestA6
%    OK=1;
%    [y6, Res6]=Arith06(xC);   % encoding
%    yout=y6;
%    xR=Arith06(y6);             % decoding
%    for k=1:xCno
%       disp(['Number of bits for sequence ',int2str(k),' is ',int2str(Res(k,3))]);
%       if (sum(abs(xR{k}-xC{k})))
%          disp(['Sequence no ', int2str(k),' has difference ',...
%                int2str(sum(abs(xR{k}-xC{k})))]);
%          OK=0;
%       end
%    end
%    disp(['Total number of bits ', int2str(Res6(xCno+1,3))]);
%    if OK
%       disp(['The result for Arith06 is OK.']);
%    end
% end

% if TestA7
%    OK=1;
%    [y7, Res7]=Arith07(xC);      % encoding
%    yout=y7;
%    xR=Arith07(y7);             % decoding
%    for k=1:xCno
%       disp(['Number of bits for sequence ',int2str(k),' is ',int2str(Res(k,3))]);
%       if (sum(abs(xR{k}-xC{k})))
%          disp(['Sequence no ', int2str(k),' has difference ',...
%                int2str(sum(abs(xR{k}-xC{k})))]);
%          OK=0;
%       end
%    end
%    disp(['Total number of bits ', int2str(Res7(xCno+1,3))]);
%    if OK
%       disp(['The result for Arith07 is OK.']);
%    end
% end


%    tic; 
%    [y6, Res6] = Arith06(xC);
%    disp(['Arith06 used ',num2str(toc),' seconds.']);
%    tic; 
   [y7, Res7] = Arith07(xC);
   yout = y7;
   delta=Res7(2,3);

return;






