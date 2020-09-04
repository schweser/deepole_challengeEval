function dataArrayObj = dilatemask(dataArrayObj,nDilate,type)


%DILATEMASK Dilates mask.
%
%   DILATEMASK Dilates a mask.
%
%   Syntax
%
%   DILATEMASK(A,n)
%
%
%
%   Description
%
%   DILATEMASK(A,n) dilates n times the N-D array A.
%
%   DILATEMASK(A,n,type) If type is equal to 2d it dilates the mask in x
%   and y coordinates slice by slice.
%   (Function supports in-place call using A.)
%
%
%   See also: ERODEMASK, IMDILATE

% F Schweser, 2009/07/23, mail@ferdinand-schweser.de
% V.2 David Lopez 2011/07/01 If type is 2d, it perfoms a 2d dilation
% v.2.1 2011/07/12 - D Lopez Type default value set up to '3d'to perform
% V.2.1 A Deistung 2011/07/01 - now also works with mids-objects




if nargin < 2
    error('Function requires two input arguments.')
end

if nargin < 3
    %default mode set up to brain
    type = '3d';
end

if isobject(dataArrayObj)
    dataArray = dataArrayObj.img;
elseif isstruct(dataArrayObj)
    if isfield(dataArrayObj, 'img')
        dataArray = dataArrayObj.img;
    else
        error('The img field is not available. Please pass a mids-object, struct with the field img, or a data array to erodemask!')
    end
else
    dataArray = dataArrayObj;
end


if ~strcmp(type,'2d')
    dilateKernel = ones(3,3,3);
else
    dilateKernel = ones(3,3);
end
for jDilate = 1:nDilate
    if strcmp(type,'2d')
        for jSlice = 1:size(dataArray,3)
            dataArray(:,:,jSlice) = imdilate(dataArray(:,:,jSlice),dilateKernel);
        end
    else
        dataArray = imdilate(dataArray,dilateKernel);
    end
end



if isobject(dataArrayObj) || isstruct(dataArrayObj)
    dataArrayObj.img = dataArray;
else 
    dataArrayObj = dataArray;
end

end