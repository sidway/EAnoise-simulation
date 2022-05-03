function plot_transferfunction(freq, transfer_function, config, trast, color,name)


semilogx(freq, real(transfer_function),trast,'color',color, 'linew', 2,'displayName', name); grid on; hold on
semilogx(freq, imag(transfer_function),trast,'color',color, 'linew', 2); 

set(gca, 'xtick', config.plotx); set(gca,'xticklabel', config.strx); 
ylim('auto'); xlim([config.fmin config.fmax])
xlabel('Frequência [Hz]');
ylabel('Função Transferencia [-]')

set(gca,'fontsize', 16)