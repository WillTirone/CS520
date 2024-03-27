function vec_diffs = vector_comparison (A, B) 
%  vec_diffs = vector_comparison (A, B);
%
%  provides comparisons between data arrays A and B of the same dimensions  
%                                       size(B) = size(A) 
%  
% Output: vec_diffs.err     the difference in F-norm between Acs and Bcs  
%                  Xcs:= X centered and scaled by Euclidean length length
%         vec_diffs.sim     the similarity between Acs and Bcs  
%         vec_diffs.akl     the KL score with Acs as the host 
%         vec_diffs.bkl     the KL score with Bcs as the host

asize = size(A); 
bsize = size(B); 

Acentered = A - sum( A, "all")/prod(asize);
Bcentered = B - sum( B, "all")/prod(bsize); 

Alength = norm( Acentered, 'fro');
Blength = norm( Bcentered, 'fro'); 

Acs = Acentered/Alength;        % centered and scaled 
Bcs = Bcentered/Blength;  

derr = norm( Acs - Bcs,  'fro');  
dsim = sum(  Acs .* Bcs, "all");

%% ... output 

vec_diffs.err = derr;
vec_diffs.sim = dsim;

%% 
fprintf('\n     display the histograms ... ')
figure 
subplot(2,1,1) 
histogram( Acs(:) );
subplot(2,1,2) 
histogram( Bcs(:) );

end

%% programmer 
%  Xiaobai Sun 
%  Duke CS 
