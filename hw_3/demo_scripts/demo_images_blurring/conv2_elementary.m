function  Xf = conv2_elementary( X, f )
%  Xf = conv2_elementary( X, f ); 
%  X:        2D data array 
%  f:        filter, odd size in each dimension (for code readability) 
%  Xf:       the same size as X, Xf is X convolved with filter f (with zero boundary conditions) 


[mx,nx] = size( X );
[mf,nf] = size( f );

mh = (mf-1)/2;     % #neighbors on each side of the middle   
nh = (nf-1)/2;

Y = zeros(mx+mf-1, nx+nf-1);    % zero padding at the boundaries to 
                                % supress if-statements for border checking
                                
Y(mh+(1:mx), nh+(1:nx)) = X; 

for i = 1:mx
    for j = 1:nx
        Xf(i, j ) = sum( Y( mh+i+(-mh:mh), nh+j+(-nh:nh) ) .* f, 'all' ) ;
    end
end
  
return 

%% Programmer 
%% Xiaobai Sun 
%% Duke CS 
