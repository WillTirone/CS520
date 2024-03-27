function  X = GaussSeidel_deconv_steps( Xf, f, kmax, X0  )
% X = Gauss_Seidel__deconv_steps( Xf, f, kmax, X0  ) ; 
% 
%  Xf:       data convolved with f (with boundary conditions) 
%  f :       filter, an odd size per dimension, center element is dominant  
%  X :       Xf deconvolved 

%% ... 

[mx,nx] = size( Xf );
[mf,nf] = size( f );

mh = (mf-1)/2;
nh = (nf-1)/2;

fc = f( mh+1, nh+1 );           % the center element 
fgauss = - f/fc;                % scaling by the diagonal constant, D=I 
fgauss(mh+1, nh+1) = 0;         % without the center element 

%% ... 

B  = Xf/fc;

X = zeros(mx+mf-1, nx+nf-1);    % zero padding at the boundaries 
Y = X;

X(mh+(1:mx),nh+(1:nx)) = X0 ;   % the initial iterate 

for k = 1:kmax                  % Jacobi iteration sweeps 
  % sweep 
  for i = 1:mx
    for j = 1:nx 
      X( mh+i, nh+j ) = sum( X(mh+i+(-mh:mh), nh+j+(-nh:nh)) .* fgauss,'all') + B(i,j); 
    end
  end 
end

X = X(mh+(1:mx),nh+(1:nx));      % remove zero buffers 

return 

%%
%%  Xiaobai Sun 
%%  Duke CS 
%%  
