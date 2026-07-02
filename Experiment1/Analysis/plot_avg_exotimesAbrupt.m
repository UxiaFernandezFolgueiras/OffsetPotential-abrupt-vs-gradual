function plot_meds_exotimes(tiempo,average,datm)

Ncond=size(average,3);
rgb=rand(Ncond,3);
figure
pos=1;
for ch=1:64
    for cond=1:Ncond
          subplot(8,8,pos)
          plot(tiempo,average(ch,:,cond),'Color',rgb(cond,:))
          hold on
    end
    axis([tiempo(154) tiempo(667) -30 30])
    title([num2str(ch),' ',num2str(datm{1}.label{ch})])
    pos=pos+1;
end
print -dpng -r300 meds_exotimes