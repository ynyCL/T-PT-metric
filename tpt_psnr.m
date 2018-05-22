function Q = tpt_psnr(I1, I2, param)
% argument of the function
% I1: reference image
% I2: test image
% param：input parameters
% This is the code from the paper: Nanyang Ye, Maria Perez-Ortiz and Rafal Mantiuk. Trained Perceptual Transform For Quality Assessment of High Dynamic Range Images and Video
if max(I1(:))< 1
    warning('Luminance very low, please check whether use the correct luminance')
end

if ~exist('param')
    disp('using default value')
    params.m = 78.8438;
    params.n = 0.1593;
    params.c1 = 0.14249;
    params.c2 = 2.192;
    params.c3 = 0.30499;
else
    if isstruct(param)
        params = param;
    else
        params.m = param(1);
        params.n = param(2);
        params.c1 = param(3);
        params.c2 = param(4);
        params.c3 = param(5);
    end
end

p_peak = pq2_encode(1e4, params);

P1 = pq2_encode(get_luminance(I1), params);
P2 = pq2_encode(get_luminance(I2), params);

MSE = sum((P1(:)-P2(:)).^2)./numel(P1);
Q = 20 * log10( p_peak / sqrt(MSE) );
Q = double(Q);
end

function Y = get_luminance( img )
% Return 2D matrix of luminance values for 3D matrix with an RGB image

dims = find(size(img)>1,1,'last');

if( dims == 3 )
    Y = img(:,:,1) * 0.212656 + img(:,:,2) * 0.715158 + img(:,:,3) * 0.072186;
elseif( dims == 1 || dims == 2 )
    Y = img;
else
    error( 'get_luminance: wrong matrix dimension' );
end

end

function V = pq2_encode(l, params)
L = 10000;
m = params.m;
n = params.n;
c1 = params.c1;
c2 = params.c2;
c3 = params.c3;


hdrin = double(l)./L;
alpha = hdrin.^n;

V = ( (alpha.*c2 + c1)./(1+alpha.*c3) ).^m;

end
