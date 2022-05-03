%% Plot absorção
function plot_absorption(freq, absorption, config, trast,color)


semilogx(freq, absorption,trast, 'linew', 3,'color', color); grid on

set(gca, 'xtick', config.plotx); set(gca,'xticklabel', config.strx); 
set(gca, 'ytick', config.ploty); set(gca,'yticklabel', config.stry); 
ylim([0 1]); xlim([100 6300])
xlabel('Frequência [Hz]');
ylabel('\alpha [-]')

set(gca,'fontsize', 16)