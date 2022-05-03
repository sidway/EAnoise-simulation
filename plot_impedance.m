function plot_impedance(freq, impedance, config, trast, color)


subplot(211)
semilogx(freq, real(impedance),trast,'color',color, 'linew', 1.7); hold on;
grid on;

ylim('auto')
xlim([100 10000]); 
ylabel('Parte real [$\frac{Pa s}{m}$]','Interpreter','latex');
set(gca,'fontsize', 16)
set(gca, 'xtick', config.plotx); set(gca,'xticklabel', config.strx);

subplot(212)
semilogx(freq, imag(impedance),trast,'color',color, 'linew', 1.7); hold on;
grid on


ylim('auto')
xlim([100 10000]); 
ylabel('Parte imaginaria [$\frac{Pa s}{m}$]','Interpreter','latex');
xlabel('Frequência [Hz]');
set(gca,'fontsize', 16)
set(gca, 'xtick', config.plotx); set(gca,'xticklabel', config.strx); 
% ylim([-1000 1500])