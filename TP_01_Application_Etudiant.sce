// TP1 -- application etudiante
// OUATTARA SAN CHAMAD ALLAN 20240206
// OUATTARA ANITA FLORIANE 20220044
// OUEDRAOGO Christiane Valérie 20230655

clear;
exec("C:\Users\user\Desktop\Nouveau dossier\TP_01_Outils_Quadrature.sce", -1);

// Modele continu : f(x) = exp(x)
function y = modele(x)
    y = exp(x);
endfunction

Iref = exp(1) - 1;
ns = [4 8 16 32];

ET = zeros(1, length(ns));
ES = zeros(1, length(ns));
errT = zeros(1, length(ns));
errS = zeros(1, length(ns));

for k = 1:length(ns)
    n = ns(k);
    [t, y] = echantillonner(modele, 0, 1, n);

    ET(k) = trapezes(t, y);
    ES(k) = simpson(t, y);
    errT(k) = abs(ET(k) - Iref);
    errS(k) = abs(ES(k) - Iref);

    mprintf("n=%2d : T=% .10f, erreur T=% .3e ; S=% .10f, erreur S=% .3e\n", ..
        n, ET(k), errT(k), ES(k), errS(k));
end

mprintf("\nOrdres observes entre n et 2n :\n");
for k = 1:length(ns)-1
    pT = ordre_observe(errT(k), errT(k+1));
    pS = ordre_observe(errS(k), errS(k+1));
    mprintf("n=%2d -> %2d : pT=% .4f ; pS=% .4f\n", ..
        ns(k), ns(k+1), pT, pS);
end

// Mesures de la pompe : puissance en kW, temps en minutes
tmin = [0 10 20 30 40];
P = [2.0 2.6 3.0 2.5 1.9];

// Convertir le temps en heures
th = tmin / 60;

Etrap = trapezes(th, P);
Esimp = simpson(th, P);

// Incertitude maximale due aux lectures de puissance
incertitude = 0.1 * 40 / 60;

mprintf("\nEnergie estimee par les trapezes : %.6f kWh\n", Etrap);
mprintf("Energie estimee par Simpson     : %.6f kWh\n", Esimp);
mprintf("Ecart entre les deux estimations: %.6f kWh\n", abs(Etrap - Esimp));
mprintf("Borne incertitude de lecture : %.6f kWh\n", incertitude);
