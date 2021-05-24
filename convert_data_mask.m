function convert_data_mask()
	pkg('load', 'image');
	pkg('load', 'jsonstuff');
	source_root_dir = 'data/test';
	target_root_dir = 'data/test';
	flag_resize = true;
	fine_height = 256;
	fine_width = 192;

	% transfer data root
	if ~exist(target_root_dir,'dir');
		mkdir(target_root_dir);
	end

	modes = {'test'};
	for i = 1:length(modes);
		fprintf('Start convert %s\n', modes{i});
		convert(source_root_dir, target_root_dir, modes{i}, flag_resize, fine_height, fine_width);
	end
end

function convert(source_root_dir, target_root_dir, mode, flag_resize, fine_height, fine_width)
	

	% read train pairs
	[im_names, cloth_names] = textread(['convert_data_mask_pairs.txt'],'%s %s\n');
	N = length(im_names);
	for i = 1:N;
		imname = im_names{i} ;
		cname = cloth_names{i};
		fprintf('%d/%d: %s %s\n', i, N, imname, cname);
	   
		% generate cloth mask
		im_c = imread([source_root_dir '/' 'cloth/' cname]);
		
		% generate parsing result
		im = imread([source_root_dir '/' 'image/' imname]);
		%save([source_root_dir '/' 'segment/' strrep(imname,'.jpg','.mat')],'im')


		h = size(im,1);
		w = size(im,2);
		%s_name = strrep(imname,'.jpg','.mat');
		%segment = importdata([source_root_dir '/' 'segment/' s_name]);
		%segment = segment';
		%segment = permute(segment, [2 1 3])
	
	    % if h > w
	    %     segment = segment(:,1:int32(641.0*w/h));
	    % else
	    %     segment = segment(1:int32(641.8*h/w),:);
	    % end
	    % segment = imresize(segment, [h,w], 'nearest');
	
	    pose_name = strrep(imname,'.jpg','.json');
	    % load pose
	    % pose = importdata([source_root_dir '/' 'pose/' s_name]);
	 %    fileName = [source_root_dir '/' 'pose/' pose_name]; % filename in JSON extension
		% fid = fopen(fileName); % Opening the file
		% raw = fread(fid,inf); % Reading the contents
		% str = char(raw'); % Transformation
		% fclose(fid); % Closing the file
		% data = jsondecode(str); % Using the jsondecode function to parse JSON from string
		% disp(data);

	    %pose = importdata([source_root_dir '/' 'pose/' pose_name]);
	    % disp(pose.textdata(3,1))
	    % pose = pose.pose_keypoints;
		% pose = [79.1181102362205 40.7272727272727 0.907790213823318 87.6850393700787 91.2290909090909 0.654397651553154 49.3858267716535 93.5563636363636 0.493277914822102 45.8582677165354 153.6 0.713929876685143 29.9842519685039 178.501818181818 0.802610471844673 127.748031496063 87.5054545454545 0.526449844241142 142.614173228346 159.650909090909 0.792855083942413 119.181102362205 201.076363636364 0.495145117864013 42.8346456692913 214.341818181818 0.244836983649293 0 0 0 0 0 0 92.7244094488189 222.254545454545 0.226115419587586 0 0 0 0 0 0 70.0472440944882 31.1854545454545 0.96220988035202 89.9527559055118 31.8836363636364 0.945377916097641 58.7086614173228 36.7709090909091 0.656627222895622 103.307086614173 40.0290909090909 0.842052668333054]
	 %    %pose = [1 3 5 2 4 6 7 8 10]
	 %    key_points = zeros(point_num,3);
	 %    for j = 1:point_num
	 %    	disp(j)
	 %        index = int32(pose(j))+1;
	 %        if index ~= 0
	 %        	x = 3*j-2 
	 %        	y = 3*j-1 
	 %        	z = 3*j 
	 %            key_points(j,:) = pose([x y z]);
	 %        end       
	 %    end

	 %    disp(key_points) 

		% save cloth & image, resize the results
		if flag_resize;
			im_c = imresize(im_c, [fine_height, fine_width], 'bilinear');
			imwrite(im_c, [target_root_dir '/cloth/' cname]);

			im = imresize(im, [fine_height, fine_width], 'bilinear');
			imwrite(im, [target_root_dir '/image/' imname]);
			
			%segment = imresize(segment, [fine_height, fine_width], 'nearest');

			% for j = 1:point_num
			% 	key_points(j,1) = key_points(j,1) / w * fine_width;
			% 	key_points(j,2) = key_points(j,2) / h * fine_height;
			% end
		else
			copyfile([source_root_dir '/' 'women_top/' cname], ...
				[target_root_dir '/cloth/' cname]);

			copyfile([source_root_dir '/' 'women_top/' imname] , ...
				[target_root_dir '/image/' imname]);
		end

		% save cloth mask
		mask = double((im_c(:,:,1) <= 250) & (im_c(:,:,2) <= 250) & (im_c(:,:,3) <= 250));
		mask = imfill(mask);
		mask = medfilt2(mask);
		imwrite(mask, [target_root_dir '/cloth-mask/' cname]);
	   	
	   	
		% % save parsing result
	 %    segment = uint8(segment);
	 %    pname = strrep(imname, '.jpg', '.png');
	 %    disp("SEGMENT")
	 %    disp(cmap)
	 %    imwrite(segment, [target_root_dir '/' mode '/image-parse/' pname]);
	    
	 %    % save the pose info
	 %    key_name = strrep(imname, '.jpg', '_keypoints.json');
	 %    f = fopen([target_root_dir '/' mode '/pose/' key_name], 'w');
	 %    fprintf(f,'{"version": 1.0, "people": [{"face_keypoints": [], "pose_keypoints": ');
	    
	 %    key_points = reshape(key_points', 1, 54);
	 %    str_key_points = mat2str(key_points);
	 %    str_key_points = strrep(str_key_points,' ', ', ');
	 %    fprintf(f,str_key_points);
	 %    fprintf(f,', "hand_right_keypoints": [], "hand_left_keypoints": []}]} ');  
	 %    fclose(f);
	    
	end

end

