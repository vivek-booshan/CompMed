function [k_CO, k_PP, k_MAP, k_HR] = get_k(CO_idxs, CO, FEA, T)
    k_CO = CO(CO_idxs(1)) / T.CO(CO_idxs(1));
    k_PP = FEA(CO_idxs(1), 5) / (T.ABPSys(CO_idxs(1)) - T.ABPDias(CO_idxs(1)));
    k_MAP = FEA(CO_idxs(1), 6) / (T.ABPMean(CO_idxs(1)));
    k_HR = FEA(CO_idxs(1), 7) / T.HR(CO_idxs(1));
end