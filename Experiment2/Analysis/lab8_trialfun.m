function trl = lab8_trialfun(cfg)

Fs=cfg.fsample;
event=cfg.event;

trl = [];

for i=1:length(event)
    if ~isempty(strfind(event(i).value, cfg.code)) && ~isnan(cfg.resp(i))
        begsample     = event(i).sample - cfg.prestim*Fs;       
        endsample     = event(i).sample + cfg.poststim*Fs - 1;   
        offset        = -(cfg.prestim)*Fs;                       
        trl(end+1, :) = round([begsample endsample offset]);
    end
end
