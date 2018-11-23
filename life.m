function [fe, out] = life(fg,aligned_dwi,life_discretization,num_iterations)
% 
% This function perfroms a bare minimum processing using the version of
% LiFE distributed under the encode toolbox
%
% Franco Pestilli, Indiana University, frakkopesto@gmail.com.
%

disp('running feConnectomeInit');
fe = feConnectomeInit(aligned_dwi, ...
                      fg, ...
                      'temp',[], ...
                      [], ...
                      '', ...
                      life_discretization,[1,0]);

fprintf('running feFitModel - iterations:%d\n', num_iterations);
Fit = feFitModel(feGet(fe,'model'), ...
                 feGet(fe,'dsigdemeaned'), ...
                 'bbnnls', ...
                 num_iterations, ...
                 'preconditioner');
fe = feSet(fe,'fit',Fit);
out.life.w    = feGet(fe,'fiber weights');
out.life.rmse = feGet(fe,'vox rmse');

disp('eliminatgin all the fascicles with 0 weights in the LiFE model solution.');
fg = feGet(fe,'fibers acpc');
w = feGet(fe,'fiber weights');
out.life.fg = fgExtract(fg, w > 0, 'keep');

%generate histgram data
[y, x]              = hist(out.life.rmse,40);
out.plot(1).title   = 'Connectome error';
out.plot(1).x.vals  = x;
out.plot(1).x.label = 'r.m.s.e. (image intensity)';
out.plot(1).x.scale = 'log';
out.plot(1).y.vals  = y;
out.plot(1).y.label = 'Number of voxels';
out.plot(1).y.scale = 'linear';

[y, x]              = hist(out.life.w( out.life.w > 0 ),logspace(-5,-.3,40));
out.plot(2).title   = 'Connectome fascicels weights';
out.plot(2).x.vals  = x;
out.plot(2).x.label = 'beta weight';
out.plot(2).x.scale = 'log';
out.plot(2).y.vals  = y;
out.plot(2).y.label = 'Number of fascicles';
out.plot(2).y.scale = 'linear';

