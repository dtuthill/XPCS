function [auto, autotime] = single_photon_xpcs(y, num, Ncasc, Nsub)

% Function [auto, autotime] = tttr2xfcs(y, num, Ncasc, Nsub) calculates
% the correlation and crosscorrelation between photon streams with arrival 
% times y, where num is a matrix indicating which photon corresponds to
% which photon stream

dt = max(y)-min(y);
%y = round(y(:));  %this loses information, and should not be necessary
if size(num,1)<size(num,2)
    num = num';
end
autotime = zeros(Ncasc*Nsub,1); 
auto = zeros(Ncasc*Nsub,size(num,2),size(num,2));
shift = 0;
delta = 1;
for j=1:Ncasc
    [y, k] = unique(y);
	tmp = cumsum(num);
    num = diff([zeros(1,size(num,2)); tmp(k,:)]);
    for k=1:Nsub
        shift = shift + delta;
        lag = round(shift/delta);
        [tmp,i1,i2] = intersect(y,y+lag);      %this is why were getting zero. There's no intersection
        auto(k+(j-1)*Nsub,:,:) = num(i1,:)'*num(i2,:)/delta;
        autotime(k+(j-1)*Nsub) = shift;
    end
    y = round(0.5*y);
    delta = 2*delta;
end
for j=1:size(auto,1)
    auto(j,:,:) = auto(j,:,:)*dt./(dt-autotime(j));
end


