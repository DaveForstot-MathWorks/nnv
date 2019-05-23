classdef ImageStar
    % Class for representing set of images using Star set
    % An image can be attacked by bounded noise. An attacked image can
    % be represented using an ImageStar Set
    % Dung Tran: 12/17/2018
    
    %=================================================================%
    %   a 3-channels color image is represented by 3-dimensional array 
    %   Each dimension contains a h x w matrix, h and w is the height
    %   width of the image. h * w = number of pixels in the image.
    %   *** A gray image has only one channel.
    %
    %   Problem: How to represent a disturbed(attacked) image?
    %   
    %   Use a center image (a matrix) + a disturbance matrix (positions
    %   of attacks and bounds of corresponding noises)
    %
    %   For example: Consider a 4 x 4 (16 pixels) gray image 
    %   The image is represented by 4 x 4 matrix:
    %               IM = [1 1 0 1; 0 1 0 0; 1 0 1 0; 0 1 1 1]
    %   This image is attacked at pixel (1,1) (1,2) and (2,4) by bounded
    %   noises:     |n1| <= 0.1, |n2| <= 0.2, |n3| <= 0.05
    %
    %
    %   Lower and upper noises bounds matrices are: 
    %         LB = [-0.1 -0.2 0 0; 0 0 0 -0.05; 0 0 0 0; 0 0 0 0]
    %         UB = [0.1 0.2 0 0; 0 0 0 0.05; 0 0 0 0; 0 0 0 0]
    %   The lower and upper bounds matrices also describe the position of 
    %   attack.
    %
    %   Under attack we have: -0.1 + 1 <= IM(1,1) <= 1 + 0.1
    %                         -0.2 + 1 <= IM(1,2) <= 1 + 0.2
    %                            -0.05 <= IM(2,4) <= 0.05
    %
    %   To represent the attacked image we use IM, LB, UB matrices
    %   For multi-channel image we use multi-dimensional array IM, LB, UB
    %   to represent the attacked image. 
    %   For example, for an attacked color image with 3 channels we have
    %   IM(:, :, 1) = IM1, IM(:,:,2) = IM2, IM(:,:,3) = IM3
    %   LB(:, :, 1) = LB1, LB(:,:,2) = LB2, LB(:,:,3) = LB3
    %   UB(:, :, 1) = UB1, UB(:,:,2) = UB2, UB(:,:,3) = UB3
    %   
    %   The image object is: image = ImageStar(IM, LB, UB)
    %=================================================================%
    
    
    properties
        numChannel = 0; % number of channels, e.g., color images have 3 channel
        height = 0; % height of image
        width = 0; % width of image
        
        % A box representation of an ImageStar
        % A convenient way for user to specify the attack
        
        IM = []; % center image (high-dimensional array)
        LB = []; % lower bound of attack (high-dimensional array)
        UB = []; % upper bound of attack (high-dimensional array)
        
        % 2D representation of an ImageStar
        % Convenient for reachability analysis
        Star2Ds = []; % an array of Star2D, number of stars = numChannel
            
        % 1D representation of an ImageStar
        % flattening image to a normal star set: S = c + V*a (see Star class)
        Star1Ds = []; % an array of stars, number of stars = numChannel
        

    end
    
    methods
        % constructor using 2D representation/1D representation of an ImageStar
        function obj = ImageStar(varargin)
            % @nargin = 3: IM = varargin{1}, LB = varagin{2}, UB =
            % varargin{3}
            %         = 2: Stars = varargin{1}, imageSize = varagin{2}
            %         = otherwise: IM = [], LB = [], UB = [], Stars = []
            % @IM: center image (high-dimensional array)
            % @LB: lower bound of attack (high-dimensional array)
            % @UB: upper bound of attack (high-dimensional array)
            % @Stars: 1D representation of an ImageStar (flattened ImageStar)
            
            % author: Dung Tran
            % date: 12/17/2018
            
            switch nargin
                
                case 3 % input center image and lower and upper bound matrices (box-representation)
                    
                    IM = varargin{1};
                    LB = varargin{2};
                    UB = varargin{3};
                    n = size(IM); % n(1) and n(2) are height and width of image
                                  % n(3) is number of channels
                    l = size(LB);
                    u = size(UB);

                    if n(1) ~= l(1) || n(1) ~= u(1) || n(2) ~= l(2) || n(2) ~= u(2) 
                        error('Inconsistency between center image and attack bound matrices');
                    end

                    if length(n) ~= length(l) || length(n) ~= length(u)
                        error('Inconsistency between center image and attack bound matrices');
                    end

                    if length(n) == 2 && length(l) == 2 && length(u) == 2

                        obj.numChannel = 1;
                        obj.IM = IM;
                        obj.LB = LB;
                        obj.UB = UB;
                        obj.height = n(1);
                        obj.width = n(2);

                    elseif length(n) == 3 && length(l) == 3 && length(u) == 3

                        if n(3) == l(3) && n(3) == u(3)
                            obj.numChannel = n(3);
                            obj.IM = IM; 
                            obj.LB = LB;
                            obj.UB = UB;
                            obj.height = n(1);
                            obj.width = n(2);
                        else
                            error('Inconsistent number of channels between the center image and the bound matrices');
                        end

                    else
                        error('Inconsistent number of channels between the center image and the bound matrices');
                    end

                    % converting box ImageStar to an array of 2D Stars
                    S_2D(obj.numChannel) = Star2D(); % preallocating an array of 2D Stars
                    S_1D(obj.numChannel) = Star(); % preallocating an array of 1D Stars
                    for i=1:obj.numChannel
                        c = reshape(obj.IM(:,:,i)', [obj.height * obj.width,1]);
                        lb = reshape(obj.LB(:,:,i)', [obj.height * obj.width,1]);
                        ub = reshape(obj.UB(:,:,i)', [obj.height * obj.width,1]);
                        lb = lb + c;
                        ub = ub + c;
                        B = Box(lb, ub);
                        X = B.toStar;
                        V = cell(1, X.nVar + 1);
                        for j=1:X.nVar + 1
                            A = reshape(X.V(:,j), [obj.height, obj.width]);
                            V{j} = A';
                        end
                        
                        S_2D(i) = Star2D(V, X.C, X.d); % 2D representation of the image star
                        S_1D(i) = S_2D(i).toStar; % 1D representation of the image star

                    end
                    
                    obj.Star2Ds = S_2D;
                    obj.Star1Ds = S_1D;
                    
                    
                case 2 % input 1D representation of the ImageStar and its size
                    
                    S = varargin{1}; % 1D representation of the ImageStar
                    imageSize = varargin{2}; % height and width of the image
                    n = length(S); % number of channels
                    for i=1:n
                        if ~isa(S(i), 'Star')
                            error('Input set is not 1D Star');
                        end
                    end
                    
                    if length(imageSize) ~= 2 || imageSize(1) < 1 || imageSize(2) < 1
                        error('Invalid image size');
                    end
                    
                    h = imageSize(1);
                    w = imageSize(2);
                    
                    obj.Star2Ds(n) = Star2D();
                    obj.Star1Ds = S; 
                    for i=1:n
                        obj.Star2Ds(i) = obj.Star1Ds(i).toStar2D(h, w); % get 2D representation of the image star
                    end
                    
                    obj.height = h;
                    obj.width = w; 
                    obj.numChannel = n;
                    
                case 1 % input 2D representation of an ImageStar
                    
                    S = varargin{1}; % 2D representation of an ImageStar
                    n = length(S);
                    for i=1:n
                        if ~isa(S(i), 'Star2D')
                            error('Input is not 2D represenation of an ImageStar');
                        end
                    end
                    
                    obj.Star2Ds = S; 
                    obj.numChannel = n;
                    obj.height = S(1).dim(1);
                    obj.width = S(1).dim(2);
                    S_1D(n) = Star();
                    for i=1:n
                        S_1D(i) = S(i).toStar;
                    end
                    obj.Star1Ds = S_1D;
                    
                                 
                case 0 % create an empty ImageStar

                    obj.numChannel = 0; 
                    obj.height = 0;
                    obj.width = 0;
                    obj.IM = [];
                    obj.LB = [];
                    obj.UB = [];
                    obj.Star2Ds = [];
                    obj.Star1Ds = [];
                    
                otherwise
                    
                    error('Invalid number of input arguments, (should be from 0 to 3)');
                    
            end
                        
        end
        
        % extract a single channel image
        function image = extract_channel(obj, index)
            % @index: index of the channel that is extracted
            % @image: a single channel ImageStar
            
            % author: Dung Tran
            % date: 12/17/2018
            
            if index == 0 || index > obj.numChannel
                error('Index is out of range of number of channels');
            end
            
            if ~isempty(obj.IM) && ~isempty(obj.LB) && ~isempty(obj.UB)
                new_IM = obj.IM(:,:,index);
                new_LB = obj.LM(:,:,index);
                new_UB = obj.UB(:,:,index);
                image = ImageStar(new_IM, new_LB, new_UB);
            elseif ~isempty(obj.Star2Ds)
                image = ImageStar(obj.Star2Ds(index));
            else
                error('The Image Star is empty to extract');
            end
            
            
        end
        
        
        % zero-padding an ImageStar
        % zero-padding an ImageStar results another ImageStar
        % we only need to use box representation or 2D representation for
        % this task. 
        function padded_image = zero_padding(obj, paddingSize)
            % @paddingSize: [t b l r] an 1-D array
            % @image: a new imageStar after padding           
            % @reference: https://www.mathworks.com/help/deeplearning/ug/layers-of-a-convolutional-neural-network.html
            
            % author: Dung Tran
            % date: 12/17/2018
            
            n = size(paddingSize);
            if n(1) ~= 1
                error('Padding Size should be a one row matrix');
            end
            if n(2) ~= 4
                error('Padding Size should have 4 column');
            end

            t = paddingSize(1); % top padding
            b = paddingSize(2); % botton padding
            l = paddingSize(3); % left padding
            r = paddingSize(4); % right padding

            if t < 0 || b < 0 || l < 0 || r < 0
                error('Invalid padding size');
            end
            
            if t == 0 && b == 0 && l == 0 && r == 0 % paddingSize = 0 for all direction, return the obj
                
                if ~isempty(obj.IM) && ~isempty(obj.LB) && ~isempty(obj.UB)
                    padded_image = ImageStar(obj.IM, obj.LB, obj.UB);
                elseif ~isempty(obj.Star2Ds)
                    padded_image = ImageStar(obj.Star2Ds);
                else
                    error('Image Star is empty');
                end
                   
                
            else
                
                % zero-padding for 2D representation of an image star
                if ~isempty(obj.IM) && ~isempty(obj.LB) && ~isempty(obj.UB) 
                    h = obj.height + t + b; % height of new image
                    w = obj.width + l + r; % width of new image
                    new_IM = zeros(h, w, obj.numChannel); % preallocate new image
                    new_LB = zeros(h, w, obj.numChannel); % preallocate new lower bound matrix
                    new_UB = zeros(h, w, obj.numChannel); % preallocate new upper bound matrix
                    for i=1:obj.numChannel
                        new_IM(t+1:t+obj.height, l+1:l+obj.width, i) = obj.IM(:,:,i);
                        new_LB(t+1:t+obj.height, l+1:l+obj.width, i) = obj.LB(:,:,i);
                        new_UB(t+1:t+obj.height, l+1:l+obj.width, i) = obj.UB(:,:,i);
                    end

                    padded_image = ImageStar(new_IM, new_LB, new_UB);

                % zero-padding for 2D representation of an image star  
                elseif ~isempty(obj.Star2Ds)

                    n = length(obj.Star2Ds);

                    new_Stars(n) = obj.Star2D(); % preallocating stars array (faster performance without preallocation)
                    h = obj.height + t + b; % height of new image
                    w = obj.width + l + r; % width of new image

                    for i=1:n
                        S = obj.Star2Ds(i);
                        V = cell(1, S.nVar+1); % preallocate new basic cell V
                        for j=1:S.nVar+1
                            C = zeros(h,w);                        
                            C(t+1:t+obj.height, l+1:l+obj.width) = S(:,j);
                            V{j} = C;
                        end
                        new_Stars(i) = Star2D(V, S.C, S.d);

                    end

                    padded_image = ImageStar(new_Stars);


                else
                    error('The image star is empty');
                end


            end
            
            
            
        end
        
        
        % Convolves an ImageStar 
        % Reference: https://www.mathworks.com/help/deeplearning/ug/layers-of-a-convolutional-neural-network.html
        % =================================================================%
        % ***Importance: A convolved Image Star is an ImageStar that does
        % not has a box-representation, i.e., IM = [], LB = [] and UB = []
        % The reason is that: box-representation can not precisely represent
        % a convolved ImageStar. To precisely represent a convolved ImageStar,
        % we use 2D or 1D representation. 
        % we can obtain a 2D presentation from 1D representation and vice
        % versa. The box-representation can be obtained from 1D or 2D
        % representations. Box-represenation is an over-approximation of
        % the (exact) 1D or 2D reperesentation
        %
        % *** We always use 1D/2D representation to compute the exact 
        % reachable set of a convolutional 2D layer or max pooling layer. 
        % =================================================================%
        
        function image = convolve(obj, W, padding, stride, dilation)
            % @W: is a weight matrix (filter)
            % @padding: zero-padding parameters
            % @stride: step size for traversing input
            % @dilation: factor for dilated convolution     
            % @image: convolved image (feature map) of an ImageStar which
            % is an ImageStar set with 1D and 2D representations
            
            % author: Dung Tran
            % date: 12/17/2018
            
            % referece: 1) https://ujjwalkarn.me/2016/08/11/intuitive-explanation-convnets/
            %           2) https://www.mathworks.com/help/deeplearning/ug/layers-of-a-convolutional-neural-network.html
            
            I = obj.zero_padding(padding);            
            n = size(W);
            if length(n) == 2 && I.numChannel > 1
                error('Invalid weight matrix, it should be %d-D array', I.numChannel);
            elseif length(n) == 3 && n(3) ~= I.numChannel
                error('Inconsistency between weight matrix and the image star on number of channels of the image');
            end 
            
            
            convolved_Star2Ds = Star2D();
            for i=1:I.numChannel
                
                S = I.Star2Ds(i);
                W1 = W(:, :, i);
                new_V = cell(1, S.nVar + 1); % preallocating an array of basic matrices for convolved 2D star set
                for j=1:S.nVar + 1
                    new_V{j} = ImageStar.compute_featureMap(S.V{j}, W1, stride, dilation);
                end
                convolved_Star2Ds = convolved_Star2Ds.sum(Star2D(new_V, S.C, S.d));
            end
            
            image = ImageStar(convolved_Star2Ds); % convolved image
            
        end
           
               
    end
    
    methods(Static)
        
        % compute feature map for specific input and weight
        function featureMap = compute_featureMap(I, W, stride, dilation)
            % @I: is input (after padding)
            % @W: is a weight matrix (filter)
            % @stride: step size for traversing input
            % @dilation: factor for dilated convolution     
            % @featureMap: convolved feature (also called feature map)
            
            
            % author: Dung Tran
            % date: 12/10/2018
            
            % referece: 1) https://ujjwalkarn.me/2016/08/11/intuitive-explanation-convnets/
            %           2) https://www.mathworks.com/help/deeplearning/ug/layers-of-a-convolutional-neural-network.html
            
            n = size(I); % n(1) is height and n(2) is width of input
            m = size(W); % m(1) is height and m(2) is width of the filter
            
            % I, W is 2D matrix
            % I is assumed to be the input after zero padding
            % output size: 
            % (InputSize - (FilterSize - 1)*Dilation + 1)/Stride
            
            h = floor((n(1) - (m(1) - 1) * dilation(1) - 1) / stride(1) + 1);  % height of feature map
            w = floor((n(2) - (m(2) - 1) * dilation(2) - 1) / stride(2) + 1);  % width of feature map

            % a collection of start points (the top-left corner of a square) of the region of input that is filtered
            map = cell(h, w); 
            
            for i=1:h
                for j=1:w
                    map{i, j} = zeros(1, 2);

                    if i==1
                        map{i, j}(1) = 1;
                    end
                    if j==1
                        map{i, j}(2) = 1;
                    end

                    if i > 1
                        map{i, j}(1) = map{i - 1, j}(1) + stride(1);
                    end

                    if j > 1
                        map{i, j}(2) = map{i, j - 1}(2) + stride(2);
                    end

                end
            end
            
            % compute feature map for each cell of map
            % do it in parallel using cpu or gpu
            % TODO: explore power of using GPU for this problem
            
            featureMap = zeros(1, h*w); % using single vector for parallel computation
           

            for l=1:h*w
                a = mod(l, w);
                if a == 0
                    i = floor(l/w);
                    j = w;
                else
                    j = a;
                    i = floor(l/w) + 1;
                end

                % get a filtered region
                val = 0;
                i0 = map{i, j}(1);
                j0 = map{i, j}(2);

                ie = i0;
                je = j0;
                for i=1:m(1)
                    for j=1:m(2)
                        if ie <= n(1) && je <= n(2)
                            val = val + I(ie, je) * W(i, j);
                        end
                        je = je + dilation(2);
                    end
                    je = j0;
                    ie = ie + dilation(1);
                end

                featureMap(1,l) = val;

            end

            featureMap = reshape(featureMap, [h, w]);
            featureMap = featureMap.';

        end
        
        
                
            
            

            
            
            
       
        
    end
end

