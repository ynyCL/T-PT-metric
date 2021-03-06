function Q = tpt_psnr(I1, I2, param)
% argument of the function
% I1: reference image
% I2: test image
% param：input parameters
% This is the code from the paper: Nanyang Ye, Maria Perez-Ortiz and Rafal Mantiuk. Trained Perceptual Transform For Quality Assessment of High Dynamic Range Images and Video

if max(I1(:))<= 1
    warning('Luminance very low, please check whether use the correct luminance')
end

pars(1) = 0.14249;
pars(2) = 2.192;
pars(3) = 0.30499;

p_peak = pu2_encode_par(1e4, pars);

P1 = pu2_encode_par(get_luminance(I1), pars);
P2 = pu2_encode_par(get_luminance(I2), pars);

MSE = sum((P1(:)-P2(:)).^2)./numel(P1);
Q = 20 * log10( p_peak / sqrt(MSE) );

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
